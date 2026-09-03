# Helper script untuk membuat Docker Hub secret di Kubernetes
# Usage: .\create-docker-secret.ps1 -Username "yohanesie86" -Password "YOUR_DOCKER_HUB_TOKEN"

param(
    [Parameter(Mandatory=$true)]
    [string]$Username,

    [Parameter(Mandatory=$true)]
    [string]$Password,

    [string]$Namespace = "tekton-pipelines",
    [string]$SecretName = "dockerhub-secret"
)

Write-Host "Creating Docker Hub secret '$SecretName' in namespace '$Namespace'..." -ForegroundColor Cyan

kubectl create secret docker-registry $SecretName `
    --docker-username=$Username `
    --docker-password=$Password `
    --docker-server=https://index.docker.io/v1/ `
    --namespace=$Namespace `
    --dry-run=client -o yaml | kubectl apply -f -

if ($LASTEXITCODE -eq 0) {
    Write-Host "Secret '$SecretName' berhasil dibuat/diperbarui!" -ForegroundColor Green
} else {
    Write-Host "Gagal membuat secret. Cek kredensial Docker Hub kamu." -ForegroundColor Red
    exit 1
}
