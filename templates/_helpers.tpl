{{- define "telesis-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "telesis-api.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "telesis-api.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "telesis-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "telesis-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "telesis-api.labels" -}}
helm.sh/chart: {{ include "telesis-api.chart" . }}
{{ include "telesis-api.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{- define "telesis-api.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "telesis-api.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{- define "telesis-api.componentName" -}}
{{- default .component .componentValues.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "telesis-api.componentFullname" -}}
{{- if .componentValues.fullnameOverride -}}
{{- .componentValues.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "telesis-api.fullname" .root) (include "telesis-api.componentName" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "telesis-api.componentSelectorLabels" -}}
{{ include "telesis-api.selectorLabels" .root }}
app.kubernetes.io/component: {{ include "telesis-api.componentName" . }}
{{- end -}}

{{- define "telesis-api.componentLabels" -}}
{{ include "telesis-api.labels" .root }}
app.kubernetes.io/component: {{ include "telesis-api.componentName" . }}
{{- with .componentValues.labels }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{- define "telesis-api.componentSecretName" -}}
{{- $name := "" -}}
{{- with .componentValues.secretEnv -}}
{{- $name = default "" .existingSecret -}}
{{- end -}}
{{- default .root.Values.secretEnv.existingSecret $name -}}
{{- end -}}

{{- define "telesis-api.componentSecretOptional" -}}
{{- $optional := .root.Values.secretEnv.optional -}}
{{- with .componentValues.secretEnv -}}
{{- if hasKey . "optional" -}}
{{- $optional = .optional -}}
{{- end -}}
{{- end -}}
{{- $optional -}}
{{- end -}}

{{- define "telesis-api.componentFirebaseSecretName" -}}
{{- $name := "" -}}
{{- with .componentValues.firebaseAdmin -}}
{{- $name = default "" .existingSecret -}}
{{- end -}}
{{- default .root.Values.firebaseAdmin.existingSecret $name -}}
{{- end -}}

{{- define "telesis-api.componentFirebaseKey" -}}
{{- $key := "" -}}
{{- with .componentValues.firebaseAdmin -}}
{{- $key = default "" .key -}}
{{- end -}}
{{- default .root.Values.firebaseAdmin.key $key -}}
{{- end -}}

{{- define "telesis-api.componentFirebaseMountPath" -}}
{{- $path := "" -}}
{{- with .componentValues.firebaseAdmin -}}
{{- $path = default "" .mountPath -}}
{{- end -}}
{{- default .root.Values.firebaseAdmin.mountPath $path -}}
{{- end -}}
