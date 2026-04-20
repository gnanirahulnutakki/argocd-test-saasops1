{{/*
Helper template for auto configuration promotion functionality
This template provides validation and helper functions for auto-config-promotion
*/}}

{{- define "fid.auto_config.promotion.validate" -}}
{{/* Only perform validation if autoConfigPromotion exists and is enabled */}}
{{- if hasKey .Values "autoConfigPromotion" }}
{{- if .Values.autoConfigPromotion.enabled }}

{{/* Validate storage class */}}
{{- if not (hasKey .Values.autoConfigPromotion "persistence") }}
{{- fail "autoConfigPromotion.persistence configuration is required when autoConfigPromotion is enabled" }}
{{- end }}

{{/* Validate mount path */}}
{{- $mount_path := .Values.autoConfigPromotion.volumeMountPath | required "autoConfigPromotion.volumeMountPath is required when autoConfigPromotion is enabled" -}}

{{/* Validate git configuration */}}
{{- if not (hasKey .Values.autoConfigPromotion "git") }}
{{- fail "autoConfigPromotion.git configuration is required when autoConfigPromotion is enabled. Git is the only supported provider." }}
{{- end }}
{{- $git := .Values.autoConfigPromotion.git -}}
{{- $git_repository := $git.repository | required "autoConfigPromotion.git.repository is required when autoConfigPromotion is enabled" -}}

{{/* Validate git credentials */}}
{{- if not (hasKey $git "credentials") }}
{{- fail "autoConfigPromotion.git.credentials configuration is required when autoConfigPromotion is enabled" }}
{{- end }}
{{- $git_credentials := $git.credentials -}}

{{/* Check for valid credential configuration */}}
{{- if not (or (hasKey $git_credentials "secretName") (hasKey $git_credentials "privateKey") (hasKey $git_credentials "privateKeyBase64") (and (hasKey $git_credentials "username") (hasKey $git_credentials "password"))) }}
{{- fail "Invalid git credentials configuration. Must provide either secretName, privateKey, privateKeyBase64, or both username and password" }}
{{- end }}

{{- end }}
{{- end }}
{{- end }}

{{/*
Generate the config map name
*/}}
{{- define "fid.auto_config.promotion.config_map_name" -}}
{{- if hasKey .Values "autoConfigPromotion" }}
{{- if .Values.autoConfigPromotion.enabled }}
{{- printf "%s-auto-config-promotion" (include "fid.fullname" .) -}}
{{- end }}
{{- end }}
{{- end }}

{{/*
Generate the PVC name
*/}}
{{- define "fid.auto_config.promotion.pvc_name" -}}
{{- if hasKey .Values "autoConfigPromotion" }}
{{- if .Values.autoConfigPromotion.enabled }}
{{- printf "settings-pvc" -}}
{{- end }}
{{- end }}
{{- end }}

{{/*
Generate the secret name
*/}}
{{- define "fid.auto_config.promotion.secret_name" -}}
{{- if hasKey .Values "autoConfigPromotion" }}
{{- if .Values.autoConfigPromotion.enabled }}
{{- printf "%s-auto-config-promotion" (include "fid.fullname" .) -}}
{{- end }}
{{- end }}
{{- end }}

{{/*
Generate environment configuration from settings
*/}}
{{- define "fid.auto_config.promotion.settings_env_from" -}}
{{- if hasKey .Values "autoConfigPromotion" }}
{{- if .Values.autoConfigPromotion.enabled }}
- configMapRef:
    name: {{ include "fid.auto_config.promotion.config_map_name" . | quote }}
{{- if hasKey .Values.autoConfigPromotion.git "credentials" }}
- secretRef:
    {{- if hasKey .Values.autoConfigPromotion.git.credentials "secretName" }}
    name: {{ .Values.autoConfigPromotion.git.credentials.secretName | quote }}
    {{- else }}
    name: {{ include "fid.auto_config.promotion.secret_name" . | quote }}
    {{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Generate FID environment variables
*/}}
{{- define "fid.auto_config.promotion.fid_env" -}}
{{- if hasKey .Values "autoConfigPromotion" }}
{{- if .Values.autoConfigPromotion.enabled }}
- name: GIT_DIRECTORY
  valueFrom:
    configMapKeyRef:
      name: {{ include "fid.auto_config.promotion.config_map_name" . | quote }}
      key: GIT_DIRECTORY
{{- end }}
{{- end }}
{{- end }}

{{/*
Generate volume configurations
*/}}
{{- define "fid.auto_config.promotion.volumes" -}}
{{- if hasKey .Values "autoConfigPromotion" }}
{{- if .Values.autoConfigPromotion.enabled }}
- name: {{ include "fid.auto_config.promotion.pvc_name" . | quote }}
  persistentVolumeClaim:
    claimName: {{ include "fid.auto_config.promotion.pvc_name" . | quote }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Generate volume mount configurations
*/}}
{{- define "fid.auto_config.promotion.volume_mounts" -}}
{{- if hasKey .Values "autoConfigPromotion" }}
{{- if .Values.autoConfigPromotion.enabled }}
- name: {{ include "fid.auto_config.promotion.pvc_name" . | quote }}
  mountPath: {{ .Values.autoConfigPromotion.volumeMountPath }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Supply the GIT_PRIVATE_KEY value based on if it is or is not already provided in base64 format
*/}}
{{- define "fid.auto_config.promotion.private_key" -}}
{{/* Base64 encode the provided plain text key */}}
{{- if hasKey .Values.autoConfigPromotion.git.credentials "privateKey" }}
{{- .Values.autoConfigPromotion.git.credentials.privateKey | b64enc | quote }}
{{- end }}
{{/* Return the already base64 encoded key */}}
{{- if hasKey .Values.autoConfigPromotion.git.credentials "privateKeyBase64" }}
{{- .Values.autoConfigPromotion.git.credentials.privateKeyBase64 | quote }}
{{- end }}
{{/* Provide nothing */}}
{{- end }}

{{/*
Supply the GIT_USERNAME value based on if it is or is not present
*/}}
{{- define "fid.auto_config_promotion.git_username" -}}
{{- if hasKey .Values.autoConfigPromotion.git.credentials "username" }}
{{ .Values.autoConfigPromotion.git.credentials.username | b64enc | quote }}
{{- else }}
{{ "" | b64enc | quote }}
{{- end }}
{{- end }}

{{/*
Supply the GIT_PASSWORD value based on if it is or is not present
*/}}
{{- define "fid.auto_config_promotion.git_password" -}}
{{- if hasKey .Values.autoConfigPromotion.git.credentials "password" }}
{{ .Values.autoConfigPromotion.git.credentials.password | b64enc | quote }}
{{- else }}
{{ "" | b64enc | quote }}
{{- end }}
{{- end }}