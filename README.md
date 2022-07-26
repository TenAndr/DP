1 Terraform

2 Kubespary
git clone https://github.com/kubernetes-sigs/kubespray.git
Изменяем файлы под свой кластер
mkdir inventory
cp kubespray/blob/master/inventory/sample inventory
Определим настройки кластера
./inventory

3 Раскатываем роль:
cd kubespray/
cat requirements.txt
sudo apt install sshpass
python3 get.pip.py
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
pip install -r requirements.txt
ansible-playbook kubespray/cluster.yml -e ansible_user=root -i inventory/prod/hosts.yaml -e kube_version=v1.21.9 -bKk

4 После подняти кластера идем на масер ноду
	устанавливаем traefik(папка traefik)
  редактируем traefik.yml нужно установить айпи нашего nginx, traefik-dashboard.yml устанавливаем имя сервиса
kubectl create -f crds
kubectl create -n kube-system -f traefik.yml
kubectl create -n kube-system -f traefik-dashboard.yml

5 УСТАНОВКА kubernetes-dasboard
устанавливаем хельм
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
kubectl create ns kubernetes-dashboard
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard -n kubernetes-dashboard
По умолочанию не создается объект ингресс, создаем его самостоятельно dash-ingress.yml
Дашборд доступен по ссылке --- https://kubernetes-dashboard.test.local/#/login
kubectl create serviceaccount dashboard -n kubernetes-dashboard
Создаем serviceaccount и clusterrolebinding для админского доступа к кластеру
kubectl create serviceaccount dashboard-admin-sa -n kubernetes-dashboard
kubectl create clusterrolebinding dashboard-admin-sa --clusterrole=cluster-admin --serviceaccount=kubernetes-dashboard:dashboard-admin-sa
Когда создаете serviceaccount, также создается токен, этот токен хранится в секретах, получаем токен
kubectl describe secret dashboard-admin-sa-token-lmqdk -n kubernetes-dashboard

6 Prometheus Grafana Alertmanager
Папка prom
kubectl create -f crds/
vi kube-prometheus-stack.yaml
kubectl create -n kube-system -f kube-prometheus-stack.yaml
kubectl create -f secret-etcd-certs.yaml
Проверяем что все сервисы поднялись
kubectl get po -n kube-system | grep prom

7 Копируем 
psp-restricted.yaml 
kubectl create -f psp-restricted.yaml 

8 Поднятие Gitlab по официальной инструкции
https://about.gitlab.com/install/
https://computingforgeeks.com/how-to-install-gitlab-ce-on-ubuntu-linux/

9 gitlab-runner 10.128.0.22
sudo apt-get update
sudo apt-get upgrade
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce
sudo systemctl status docker
sudo systemctl enable docker
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
sudo apt-get install gitlab-runner
systemctl status gitlab-runner.service
gitlab-runner register
gitlab-runner status
gitlab-runner list
docker login gitlab.local:4567
ТАК ЖЕ на всех нодах кластера docker login gitlab.local:4567
vi /etc/gitlab-runner/config.toml
#####################
concurrent = 1
check_interval = 0
[session_server]
  session_timeout = 1800
[[runners]]
  name = "sprint"
  url = "http://gitlab.local/"
  token = "1spMvARpny2frdNWjLww"
  executor = "docker"
  [runners.custom_build_dir]
  [runners.cache]
    [runners.cache.s3]
    [runners.cache.gcs]
    [runners.cache.azure]
  [runners.docker]
    tls_verify = false
    image = "docker:dind"
    privileged = true
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/var/run/docker.sock:/var/run/docker.sock", "/cache"]
    shm_size = 0
#########################
gitlab-runner restart

10 Установка helm на runner
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
yum install git -y
git clone https://github.com/vinhlee95/django-pg-docker-tutorial.git
helm create .helm
git add .
git commit -m "add helm"
git push
#тест проек на java выводящий текст
cd testprojectten/
helm create .helm
git add .
git commit -m "add helm"
git branch
git branch -D dev
git push
Настройка Gitlab
Заходим в проект Settings->CI/CD-> Runners (Set up a specific Runner manually) gitlab-runner register. (tags)
Заходим в проект Settings->CI/CD-> Variables (DEPLOY_TOKEN_NEW, https://www.base64decode.org/ ENCODE master node .kube/config все содержимое о кластере
