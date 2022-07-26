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


