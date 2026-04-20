{{/* vim: set filetype=mustache: */}}

{{/*
Find default elasticsearch aggregator
*/}}
{{- define "fid.curator.findDefaultAggregator" -}}
{{- $aggregators := .aggregators -}}
{{- $result := dict -}}
{{- range $agg := $aggregators -}}
  {{- if and (eq (lower $agg.name) "default") (eq $agg.type "elasticsearch") -}}
    {{- $result = $agg -}}
  {{- end -}}
{{- end -}}
{{- $result | toYaml -}}
{{- end }}

{{/*
Validate aggregator configuration
*/}}
{{- define "fid.curator.validateAggregator" -}}
{{- $aggregator := . -}}
{{- if not $aggregator -}}
ERROR: No default elasticsearch aggregator found. Please configure an aggregator named 'default' with type 'elasticsearch'
{{- else if not (eq $aggregator.type "elasticsearch") -}}
ERROR: The default aggregator must be of type 'elasticsearch', found type '{{ $aggregator.type }}'
{{- else if not (and $aggregator.host $aggregator.port) -}}
ERROR: The default elasticsearch aggregator must specify both 'host' and 'port' fields
{{- end -}}
{{- end }}

{{/*
Get curator client configuration
*/}}
{{- define "fid.curator.getClientConfig" -}}
{{- $defaultConfig := .defaultConfig -}}
{{- $aggregator := .aggregator -}}
{{- $config := deepCopy $defaultConfig -}}

{{/* Connection settings */}}
{{- if hasKey $defaultConfig "hosts" -}}
  {{- $_ := set $config "hosts" $defaultConfig.hosts -}}
{{- else if $aggregator.host -}}
  {{- $_ := set $config "hosts" (list $aggregator.host) -}}
{{- end -}}

{{- if hasKey $defaultConfig "port" -}}
  {{- $_ := set $config "port" $defaultConfig.port -}}
{{- else if $aggregator.port -}}
  {{- $_ := set $config "port" $aggregator.port -}}
{{- end -}}

{{/* Authentication settings */}}
{{- if and $defaultConfig.username $defaultConfig.password -}}
  {{- $_ := set $config "username" $defaultConfig.username -}}
  {{- $_ := set $config "password" $defaultConfig.password -}}
{{- else if and $aggregator.user $aggregator.password -}}
  {{- $_ := set $config "username" $aggregator.user -}}
  {{- $_ := set $config "password" $aggregator.password -}}
{{- end -}}

{{/* SSL settings */}}
{{- if hasKey $defaultConfig "use_ssl" -}}
  {{- $_ := set $config "use_ssl" $defaultConfig.use_ssl -}}
{{- else if hasKey $aggregator "ssl" -}}
  {{- if $aggregator.ssl.enabled -}}
    {{- $_ := set $config "use_ssl" true -}}
    {{- $_ := set $config "ssl_no_validate" (not (default true $aggregator.ssl.verify)) -}}
    {{- if $aggregator.ssl.ca_path -}}
      {{- $_ := set $config "certificate" $aggregator.ssl.ca_path -}}
    {{- end -}}
    {{- if $aggregator.ssl.cert_path -}}
      {{- $_ := set $config "client_cert" $aggregator.ssl.cert_path -}}
    {{- end -}}
    {{- if $aggregator.ssl.key_path -}}
      {{- $_ := set $config "client_key" $aggregator.ssl.key_path -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- $config | toYaml -}}
{{- end }}

{{/*
Get action list configuration
*/}}
{{- define "fid.curator.getActionList" -}}
{{- $clusterName := .clusterName -}}
{{- $logConfigs := .logConfigs -}}
{{- $curatorConfig := .curatorConfig -}}
actions:
  1:
    action: delete_indices
    description: "Delete old indices based on retention policy and cluster name"
    options:
      ignore_empty_list: true
      continue_if_exception: true
      timeout_override: 300
      exclude_pattern: "^\\..*"  # Exclude system indices
    filters:
      # First exclude system indices
      - filtertype: pattern
        kind: prefix
        exclude: true
        value: "^\\."
    {{- range $logName, $logConfig := $logConfigs }}
    {{- if $logConfig.enabled }}
      # Match the specific log type and cluster name pattern
      - filtertype: pattern
        kind: prefix
        value: {{ printf "%s-%s" $logConfig.index $clusterName | quote }}
      # Age-based filter for matched indices
      - filtertype: age
        source: name
        direction: older
        timestring: '%Y.%m.%d'
        unit: days
        unit_count: {{ $logConfig.retention_days | default "30" }}
    {{- end }}
    {{- end }}
{{- end }}
