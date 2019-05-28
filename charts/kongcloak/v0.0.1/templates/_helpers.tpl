{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kongcloak.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "kongcloak.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate hostname
*/}}
{{- define "kongcloak.hostname" }}
{{- if (not (empty .Values.config.hostname)) }}
{{- printf .Values.config.hostname }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- printf (index .Values.ingress.hosts.kongcloak 0).name }}
{{- else }}
{{- printf "%s-kongcloak" (include "kongcloak.fullname" . ) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate base_url
*/}}
{{- define "kongcloak.base_url" }}
{{- if (not (empty .Values.config.base_url)) }}
{{- printf .Values.config.base_url }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- $host := ((empty (include "kongcloak.hostname" . )) | (index .Values.ingress.hosts.kongcloak 0) (include "kongcloak.hostname" . )) }}
{{- $protocol := (.Values.ingress.tls | ternary "https" "http") }}
{{- $path := (eq $host.path "/" | ternary "" $host.path) }}
{{- printf "%s://%s%s" $protocol $host.name $path }}
{{- else }}
{{- if (empty (include "kongcloak.hostname" . )) }}
{{- printf "http://%s-kongcloak" (include "kongcloak.hostname" . ) }}
{{- else }}
{{- printf "http://%s" (include "kongcloak.hostname" . ) }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate postgres_url
*/}}
{{- define "kongcloak.postgres_url" }}
{{- $postgres := .Values.config.postgres }}
{{- if $postgres.internal }}
{{- $credentials := (printf "%s:%s" $postgres.username $postgres.password) }}
{{- printf "postgresql://%s@%s-postgres:5432/%s" $credentials (include "kongcloak.fullname" . ) $postgres.database }}
{{- else }}
{{- if $postgres.url }}
{{- printf $postgres.url }}
{{- else }}
{{- printf "postgresql://%s@%s:%s/%s" $credentials $postgres.host $postgres.port $postgres.database }}
{{- end }}
{{- end }}
{{- end }}
