# 페쇄망 환경구축 가이드


## Prerequsite
* podman
* kubectl
* [helm](https://helm.sh/docs/intro/install/)
* git

## How-to

1. (외부망 환경에서) HyperRegistry 이미지 다운로드 
   ```bash
   git clone https://github.com/tmax-cloud/HyperRegistry-Chart
   cd HyperRegistry-Chart
   chmod +x download.sh
   ./download.sh <tag> <download_dir> # ./download.sh v2.2.2 ./downloads
   ```

2. 폐쇄망 환경으로 git repo(HyperRegistry-Chart) 전체 복사

3. 폐쇄망 환경 레지스트리 설치 ([참조](https://github.com/tmax-cloud/install-registry/tree/5.0))
   * 모든 노드에서 접근할 수 있는 호스트에 설치   


4. 이미지 업로드
   ```bash
   cd <복사한_git_repo_경로>
   chmod +x ./upload.sh
   ./upload.sh ./downloads <tag> <download_dir> <registry_url> # ./update.sh v2.2.2 ./downloads 172.22.11.2:5000
   ```

5. Helm 차트 준비
   ```bash
   sed 's/__REPO__/<registry_url>/' values.yaml.tpl > values.yaml 
   sed -i 's/__TAG__/<tag>/' values.yaml
   tar -zcvf HyperRegistry-5.0.0.tgz .
   helm repo index .
   mkdir chart-repository
   mv index.yaml hyperregistry-<tag>.tgz chart-repository
   ```

6. 폐쇄망 환경 Helm 서버 디플로이
   ```bash
   podman run --name helm --rm -v ./chart-repository:/usr/share/nginx/html -p 8080:80 -d docker.io/nginx
   ```

7. HyperRegistry 설치
   ```bash
   helm repo add hyperregistry <helm_server_url> # helm repo add hyperregistry http://172.22.11.2:8080
   helm repo update
   helm install <name> hyperregistry/HyperRegistry 
   ```

## Trouble-Shoting
### x509: certificate signed by unknown authority
1. crio 재시작
   ```bash
   systemctl restart crio
   ```
