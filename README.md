# ft_serivces

-----
#### Todo
- 서비스 좀비로 만들기
- wordpress - mysql - phpmyadmin

-----
#### 참고
[참고](https://itnext.io/kubernetes-in-a-nutshell-blog-series-c3a97fce9445)
-----
#### setup.sh
- 클러스터
   ```
   export MINIKUBE_HOME=~/goinfre
   minikube start --vm-driver virtualbox
   ```
- 리눅스
   ```
   minikube start
   ```
-----
#### 
- Deployment
   - [Deployment](https://arisu1000.tistory.com/27833)
   - [공식문서](https://kubernetes.io/ko/docs/concepts/workloads/controllers/deployment/#selector)
- Service
   - [공식문서](https://kubernetes.io/ko/docs/concepts/services-networking/service/)
   - [Service1](https://arisu1000.tistory.com/27838?category=787056)
   - [Service2](https://arisu1000.tistory.com/27839?category=787056)
- Pod
   - [공식문서](https://kubernetes.io/ko/docs/concepts/workloads/pods/pod-overview/)
   - [한글사이트](https://arisu1000.tistory.com/27829?category=787056)
- [ConfigMap](https://arisu1000.tistory.com/27843?category=787056)
- [Secret](https://arisu1000.tistory.com/27844)
- [Volume](https://arisu1000.tistory.com/27849?category=787056)
- [Metrics-server](https://arisu1000.tistory.com/27856?category=787056)

-----
#### Metallb
- Service 객체의 Type을 NodePort가 아닌 LoadBalancer로 한다.
- [참고사이트](https://medium.com/@shoaib_masood/metallb-network-loadbalancer-minikube-335d846dfdbe)
- 설치
   1. Kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml
   2. [Layer2 Configuration](https://metallb.universe.tf/configuration/) 부분 yaml 파일로 만들어서 사용하기.
- 테스트
   ```
   kubectl get services
   ```
   이후 각 서비스의 External-ip로 접속하면 된다.

#### Metallb && MINIKUBE 두 개의 키워드를 같이 검색하면 잘 나오는듯?
-----
#### Volume은 왜 필요한가?
- Kubernetes에서 Deploy를 하면 파드가 생성된다. 그리고 파드는 하나의 서비스를 실행할 수 있다.
- Deploy된 Pod들은 의도치 않은 이유로 인해 삭제되었을 때 자동으로 복구 되는 힐링기능이 있다.
- 파드가 자동으로 힐링된다고 하자. 거기까지는 좋다. 하지만 파드가 자동으로 다시 시작이 되면 이전에 삭제된 파드에 있던 데이터는 어떻게 되지?
- docker run -it alpine /bin/sh 로 작업을 하고 exit 하면 작업했던 모든 기록들이 삭제되는걸 익히 알고있듯이 파드가 삭제되면 안에 있던 데이터들은 다 날아가는게 아닌가? 만약 그 안에 아주 중요한 데이터가 있다고 하면 자동 복구라는건 빛살좋은 개살구 아닌가?
- 일단은 삭제 되는게 맞다! 하지만 Kubernetes는 파드 안에 있는 컨테이너의 어느 특정 위치를 Volume로 지정해서 데이터를 저장시키는 엄청난 기능이 있다!
- 이 기능을 사용하면 파드가 재시작되어도 우리가 지정했던 그 위치의 데이터는 삭제되기 이전 그 상태 그대로 남아있다!
- Volume 기능은 데이터를 저장할 목적으로도 사용되지만 이 목적만이 아니라 어떤 파일 자체를 컨테이너에 넣을 수 있는 기능도 제공한다.(보통 설정 파일을 넣는 역할을 하는거 같다.)
   - 영구적으로 파일을 저장 -> persistentVolumeClaim
   - 설정 파일 넣기 -> ConfigMap
- 먼저 Deployment의 spec.containers.VolumeMounts 설정을 통해서 Volume 될 위치를 정한다.
- spec.Volume에서 persistentVolumeClaim, configMap 등을 지정해준다.
- ConfigMap은 보통 외부로 노출되어도 되는 설정일 경우 kind:ConfigMap으로 하고 외부로 노출되면 안되는 경우는 kine:secret 으로 한다.
- [ConfigMap](https://itnext.io/learn-how-to-configure-your-kubernetes-apps-using-the-configmap-object-d8f30f99abeb)
- [Secret](https://medium.com/better-programming/how-to-use-kubernetes-secrets-for-storing-sensitive-config-data-f3c5e7d11c15)
- [Volume]
   - [한글사이트](https://itnext.io/learn-about-the-basics-of-kubernetes-persistence-part-1-b1fa2847768f)

-----
#### 컨테이너로 파일 전송하는 법
- 호스트에서 컨테이너로
  ```
  docker cp /path/foo.txt mycontainer:/path/foo.txt
  ```
- 컨테이너에서 호스트
  ```
  docker cp mycontainer:/path/foo.txt /path/foo.txt
  ```

-----
#### Kubectl 명령어

- [Kubectl cheat sheet](https://kubernetes.io/ko/docs/reference/kubectl/cheatsheet/)

-----
#### Minikube 명령어

- 기본 Port range 바꾸는 법
   ```
   minikube start --extra-config=apiserver.service-node-port-range=21-32767
   ````
- Dashboard
  ```
  minikube dashboard
  ```
- Service 확인하기
  ```
  minikube service list
  ```
- minikube ip -> 나중에 ingress로 연결되서 nginx index.html 화면 띄움
  ```
  minikube ip
  ```
- 애드온 확인
  ```
  minikube addons list
  ```
- addon 활성화
  ```
  minikube addons enable [addome]
  ```
- env
  ```
  eval $(minikube docker-env)
  ```

-----
#### yaml 파일
- :punch:[쿠버네티스 서비스 생성 가이드](https://waspro.tistory.com/520)
- [port vs nodePort vs targetPot](https://matthewpalmer.net/kubernetes-app-developer/articles/kubernetes-ports-targetport-nodeport-service.html)
- ports
   - nodePort : 외부와 미니큐브를 연결시켜줌
   - port : 미니큐브와 서비스 객체를 연결
   - targetPort : 파드와 서비스 객체를 연결
   - 최종적으로 외부의 요청은 컨테이너가 EXPOSE하고 있는 포트와 연결된다.
-----
#### nginx
![nginx](images/nginx3.jpg)
- [Nginx in alpine](https://wiki.alpinelinux.org/wiki/Nginx)
- [Very good](https://www.cyberciti.biz/faq/how-to-install-nginx-web-server-on-alpine-linux/)
- [index.html 꾸미기](https://www.w3schools.com/tags/tryit.asp?filename=tryhtml5_input_type_button)
- ssh 연결
  ```
  minikube service nginx // 포트를 찾고
  ssh sanam@(minikube ip) -p PORT
  ```
- 301...to...443의 의미가 뭘까...
   - http://localhost 로 접속하면 자동으로 https 로 이동한다는걸까..?
-----
#### ftps

- 파일 전송
  ```
    curl ftp://EXTERNAL-IP:21 --ssl -k --user sanam -T filename
    enter password : 123456789
    // --ssl : ftps 쓰기 위함
    // -k : 인증 문제 무시
  ```
- 파일 다운로드
   ```
   curl -u sanam:123456789 'ftp://EXTERNAL-IP:21/toDOWNLOAD' --ssl -k -o ./DOWNLOADED
   ```
- 파일 전송 확인
  ```
    kubectl get pods // ftp 파드 이름 확인
    kubectl exec -it [POD_NAME] -- sh // ftps 컨테이너 접속
    cd ftps/sanam // 전송된 파일 저장되는 곳
  ```

-----
#### wordpress, Mysql, Phpmyadmin
- 왜인지는 모르겠는데 wordpress의 external ip가 minikube ip 언저리에 있어야지만 잘 실행된다.
##### phpmyadmin
   - id : admin
   - password : tkdgur123
##### wordpress
   - id : admin, user1, user2
   - password : tkdgur123
***wordpress같은 경우 설정 파일에 있는 host의 주소가 external ip와 같거나 비슷해야지 wordpress 사이트에 접속이 된다. 따라서 인위적으로 값을 바꿔줘야하는데 두가지 방법있음***
   1. wordpress_service.yaml에서 externalIPs 옵션을 주는 방법. 이 하지만 이 방법을 쓰면 wordpress가 노출되는 포트가 두개가 되므로 pdf에서 컷 된다. 따라서 아래 방법 사용.
   2. 일단 wordpress를 실행 시키는데, 이 때 wordpress.sql을 데이터 베이스에 넣지 않는다. 먼저 서비스를 문제 없이 작동시키고 서비스가 돌아가면 생기는 ***external ip***를 가져와서 wordpress.sql 파일과 wp-config.php 파일에 넣어준다. 그리고 kubectl 명령어들을 이용해서 wordpress 컨테이너에 설정 파일들을 다시 넣어주고 데이터베이스에 wordpress.sql 넣어준다.
      - 이 방법말고 configMap 파일 형태를 이용해서 하는게 더 간편할거 같다!!
         - 먼저 wordpress.sql 데이터를 넣지 않은 상태로 시작한다.
         - 그리고 external ip가 나오면 그 값을 wordpress_sql.yaml의 host 부분에 넣어준다. 
         - 이 후 kubectl apply -f wordpress_sql.yaml로 적용해주고 kubectl exec 를 통해서 wordpress.sql을 데이터베이스에 넣어준다.(흠... 안되려나?)
      - wordpress에 데이터를 넣어줄 때 한번에 들어가는 경우는 거의 없다. 쉘 스크립트 등을 통해서 데이터가 잘 들어갈 때 까지 무한 반복 시켜주자.(until 명령어 사용하면 편함)

- Dockerfile
  - [Wordpress in alpine](https://wiki.alpinelinux.org/wiki/WordPress)
  - [Mysql in alpine](https://wiki.alpinelinux.org/wiki/MariaDB)
  - [Phpmyadmin in alpine](https://wiki.alpinelinux.org/wiki/PhpMyAdmin)
- kustomization
  - [wordpress mysql 한국어](https://cleanupthedesk.tistory.com/16)
  - https://wiki.alpinelinux.org/wiki/WordPressa
  - [공홈 가이드](https://kubernetes.io/ko/docs/tutorials/stateful-application/mysql-wordpress-persistent-volume/)
  - [차근차근 가이드](https://medium.com/@containerum/how-to-deploy-wordpress-and-mysql-on-kubernetes-bda9a3fdd2d5)
  - [What is PV, PVC?](https://kubernetes.io/ko/docs/concepts/storage/persistent-volumes/)

-----
#### Grafana, Influxdb, Telegraf
- telegraf는 각종 데이터를 수집한다.
- influxdb는 시계열 데이터를 위한 DB
- grafana는 데이터를 시각화한다.
> telegraf로 수집한 데이터를 influxdb로 넘기고 grafana로 시각화하자!
>> influxdb, telegraf, grafana 순서로 세팅하자!
