{{/*
Expand the name of the chart.
*/}}
{{- define "node64.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "node64.fullname" -}}
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
{{- define "node64.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "node64.labels" -}}
helm.sh/chart: {{ include "node64.chart" . }}
{{ include "node64.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "node64.selectorLabels" -}}
app.kubernetes.io/name: {{ include "node64.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "node64.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "node64.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Validated log level for NODE64_LOG_LEVEL
*/}}
{{- define "node64.logLevel" -}}
{{- $levels := list "debug" "info" "warn" "error" }}
{{- if not (has .Values.logLevel $levels) }}
{{- fail (printf "logLevel must be one of %s, got %q" (join ", " $levels) (toString .Values.logLevel)) }}
{{- end }}
{{- .Values.logLevel }}
{{- end }}

{{/*
Validated log format for NODE64_LOG_FORMAT
*/}}
{{- define "node64.logFormat" -}}
{{- $formats := list "text" "json" }}
{{- if not (has .Values.logFormat $formats) }}
{{- fail (printf "logFormat must be one of %s, got %q" (join ", " $formats) (toString .Values.logFormat)) }}
{{- end }}
{{- .Values.logFormat }}
{{- end }}

{{/*
Validated boolean for NODE64_TRUST_PROXY
*/}}
{{- define "node64.trustProxy" -}}
{{- $value := toString .Values.trustProxy }}
{{- if not (has $value (list "true" "false")) }}
{{- fail (printf "trustProxy must be true or false, got %q" $value) }}
{{- end }}
{{- $value }}
{{- end }}
