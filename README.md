1 Terraform
2 Kubespary
git clone https://github.com/kubernetes-sigs/kubespray.git
Изменяем файлы под свой кластер
mkdir inventory
cp kubespray/blob/master/inventory/sample inventory
Определим настройки кластера
./inventory

Раскатываем роль:
cd kubespray/
cat requirements.txt
sudo apt install sshpass
python3 get.pip.py
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
pip install -r requirements.txt
ansible-playbook kubespray/cluster.yml -e ansible_user=root -i inventory/prod/hosts.yaml -e kube_version=v1.21.9 -bKk

После подняти кластера идем на масер ноду
	устанавливаем traefik(папка traefik)
  редактируем traefik.yml нужно установить айпи нашего nginx, traefik-dashboard.yml устанавливаем имя сервиса
kubectl create -f crds
kubectl create -n kube-system -f traefik.yml
kubectl create -n kube-system -f traefik-dashboard.yml

