{{/*
Provides environment variables that either enable or disable zipkin integration
in the v8 services, depending on whether or not zipkin is enabled.
*/}}
{{- define "zipkin.v8.env" }}
- name: MANAGEMENT_TRACING_ENABLED
  value: "{{ if .Values.zipkin.enabled }}true{{ else }}false{{ end }}"
{{- end }}