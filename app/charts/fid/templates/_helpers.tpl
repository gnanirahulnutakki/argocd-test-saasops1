{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "fid.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fid.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "fid.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Generate the tenant name from release namespace
*/}}
{{- define "tenant.name" -}}
{{- trimPrefix "duploservices-" .Release.Namespace -}}
{{- end -}}

{{/*
Pod labels
*/}}
{{- define "iddm.podLabels" -}}
{{- if .context.Chart.AppVersion }}
app.kubernetes.io/version: {{ .context.Chart.AppVersion | quote }}
{{- end }}
{{- if .component.podLabels }}
{{ .component.podLabels | toYaml }}
{{- end }}
{{- end }}

{{/*
Velero Backup/Restore labels
*/}}
{{- define "iddm.velero.labels" -}}
helm.sh/chart: {{ include "fid.chart" . }}
app.kubernetes.io/name: {{ include "fid.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: velero
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
radiantlogic.io/environment: {{ include "tenant.name" . }}
radiantlogic.io/app: {{ include "fid.name" . }}
{{- with .Values.backup.velero.labels }}
{{ . | toYaml }}
{{- end }}
{{- end }}

{{/*
Velero Backup/Restore annotations
*/}}
{{- define "iddm.velero.annotations" -}}
{{- .Values.backup.velero.annotations | default dict | toYaml -}}
{{- end -}}

{{/*
Generate the logging annotations
*/}}
{{- define "logging.annotations" -}}
{{- $loggingEnabled := and (not ((.component.logging).annotations).disabled | default false) .context.Values.logging.annotations.enabled -}}
{{- if $loggingEnabled }}
logging.radiantlogic.io/enabled: "true"
{{- range $key, $value := .context.Values.logging.annotations.config }}
logging.radiantlogic.io/{{ $key }}: {{ $value | quote }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "fid.labels" -}}
helm.sh/chart: {{ include "fid.chart" . }}
{{ include "fid.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "fid.selectorLabels" -}}
app: {{ include "fid.name" . }}
app.kubernetes.io/name: {{ include "fid.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
radiantlogic.io/environment: {{ include "tenant.name" . }}
{{- if .Values.alternateName }}
radiantlogic.io/app: {{ .Values.alternateName }}
{{- else }}
radiantlogic.io/app: {{ include "fid.name" . }}
{{- end }}
{{- end }}

{{/*
Service Selector labels
*/}}
{{- define "fid.serviceSelectorLabels" -}}
app: {{ include "fid.name" . }}
app.kubernetes.io/name: {{ include "fid.name" . }}
{{- end }}

{{/*
Common workload labels
*/}}
{{- define "common.labels" -}}
helm.sh/chart: {{ include "fid.chart" . }}
{{ include "common.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Common workload selector labels
*/}}
{{- define "common.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fid.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
radiantlogic.io/environment: {{ include "tenant.name" . }}
{{- if .Values.alternateName }}
radiantlogic.io/app: {{ .Values.alternateName }}
{{- else }}
radiantlogic.io/app: {{ include "fid.name" . }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "fid.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "fid.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create image pull credentials
*/}}
{{- define "imagePullSecret" }}
{{- with .Values.imageCredentials }}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}}}" .registry .username .password .email (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end }}
{{- end }}

{{/*
Define the fid.detectFluentdConfigType helper template.
This template determines the enabled Fluentd configuration type based on the values provided in the Helm values.yaml file.
It supports detection of the old configuration format (metrics.fluentd), the new format (logging.fluentd), or no Fluentd configuration.
The template returns "old", "new", or "none" depending on the detected configuration type.
*/}}
{{- define "fid.detectFluentdConfigType" -}}
  {{- /* Check for new configuration first */ -}}
  {{- if and (hasKey .Values "logging") .Values.logging .Values.logging.enabled (hasKey .Values.logging "fluentd") .Values.logging.fluentd (hasKey .Values.logging.fluentd "enabled") .Values.logging.fluentd.enabled -}}
    {{- print "new" -}}
  {{- else if and (hasKey .Values "metrics") .Values.metrics (hasKey .Values.metrics "fluentd") .Values.metrics.fluentd (hasKey .Values.metrics.fluentd "enabled") .Values.metrics.fluentd.enabled -}}
    {{- print "old" -}}
  {{- else -}}
    {{- print "none" -}}
  {{- end -}}
{{- end -}}

{{/*
Velero backup retention (days to hours)
*/}}
{{- define "backup.retention" -}}
{{- $retention := .Values.backup.velero.retention | default 7 -}}
{{- printf "%dh" (mul $retention 24) -}}
{{- end -}}
