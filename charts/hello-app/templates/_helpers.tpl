{{-/*
Return the chart’s name (or `.Values.nameOverride` if set).
*/ -}}
{{- define "hello-app.name" -}}
{{- default .Chart.Name .Values.nameOverride -}}
{{- end -}}

{{-/*
Return a safe full name for resources: `<name>-<release>`.
*/ -}}
{{- define "hello-app.fullname" -}}
{{- printf "%s-%s" (include "hello-app.name" .) .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
