{{- define "fid.v8.zk_values" -}}
- name: ZK_CONNECTION_STRING
  valueFrom:
    configMapKeyRef:
      name: {{ template "fid.fullname" . }}
      key: ZK_CONN_STR
- name: ZK_USERNAME
  valueFrom:
    secretKeyRef:
      name: rootcreds-{{ template "fid.fullname" . }}
      key: zk-username
- name: ZK_PASSWORD
  valueFrom:
    secretKeyRef:
      name: rootcreds-{{ template "fid.fullname" . }}
      key: zk-password
{{- end }}