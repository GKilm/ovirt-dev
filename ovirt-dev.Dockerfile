FROM centos:8

ADD ./static-files/systemctl.py /usr/bin/systemctl

RUN \
    # 添加用户
    useradd --create-home -G wheel ovirt-dev && \
    echo "ovirt-dev:ovirt-dev" | chpasswd && \
    # 为systemctl添加权限
    chmod +x /usr/bin/systemctl && \
    # 替换仓库并安装相关软件
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* &&\
    dnf install -y http://resources.ovirt.org/pub/yum-repo/ovirt-release44.rpm && \
    dnf install -y libicu java-11-openjdk-devel mailcap unzip openssl bind-utils  postgresql postgresql-contrib python3-dateutil python3-cryptography python3-m2crypto python3-psycopg2 \
    python3-jinja2 python3-libxml2 python3-daemon python3-otopi python3-ovirt-setup-lib ansible ansible-runner-service-dev ovirt-ansible-roles ovirt-imageio-daemon python3-distro \
    #python-flake8 python-pep8 python-docker-py python2-isort ovirt-engine-metrics \
    python3-ovirt-engine-sdk4 python3-ansible-lint ovirt-engine-wildfly ovirt-engine-wildfly-overlay \
    # 安装额外的应用
    Xvfb sudo git bash-completion make && \
    # 安装postgres客户端
    dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-42.0-32.noarch.rpm &&\
    dnf remove -y postgresql postgresql-server && dnf module -y disable postgresql &&\
    dnf install -y postgresql12 --repo pgdg12 && \
    # 配置ansible run service
    systemctl enable ansible-runner-service && \
    # 使用tar包安装maven
    curl https://dlcdn.apache.org/maven/maven-3/3.9.3/binaries/apache-maven-3.9.3-bin.tar.gz | tar -xz -C /opt/ &&\
    # 移除postgresql安装库
    dnf remove -y pgdg-redhat-repo-42.0-32.noarch &&\
    # 清理缓存
    dnf clean all && rm -rf /var/cache/*

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk

ENV PATH=$PATH:/opt/apache-maven-3.9.3/bin

ADD ./static-files/ansible-runner-service-config.yaml /etc/ansible-runner-service/config.yaml

ADD --chown=ovirt-dev ./static-files/gwt-module.dtd /home/ovirt-dev/.lemminx/cache/http/google-web-toolkit.googlecode.com/svn/tags/2.5.1/distro-source/core/src/gwt-module.dtd

USER ovirt-dev 

RUN \
    # 拉取工程
    git clone -b ovirt-engine-4.4.10.7 https://github.com/oVirt/ovirt-engine.git /home/ovirt-dev/ovirt-engine && \
    # 构建工程
    cd /home/ovirt-dev/ovirt-engine && make clean install-dev SKIP_CHECKS=1 PREFIX=/home/ovirt-dev/ovirt-exec EXTRA_BUILD_FLAGS="-Dgwt.compiler.localWorkers=1 -Dgwt.jvmArgs='-Xms1G -Xmx3G'" DEV_EXTRA_BUILD_FLAGS_GWT_DEFAULTS="-Dgwt.userAgent=safari -Dgwt.locale=zh_CN,en_US" && mvn dependency:sources && mvn dependency:resolve -Dclassifier=javadoc

WORKDIR /home/ovirt-dev/ovirt-engine
