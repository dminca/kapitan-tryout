# My Readme

Target: prd

# INVENTORY

```
- gitlab.config
- common
- gitlab.helm

```


```
_reclass_:
  environment: base
  name:
    full: prd
    short: prd
charts:
  gitlab:
    chart_path: charts/gitlab/6.8.3
    fqdn: gitlab.in.example.com
    helm_values:
      certmanager:
        install: false
      certmanager-issuer:
        email: sre@example.com
      gitlab:
        gitlab-shell:
          minReplicas: 1
        migrations:
          enabled: true
        sidekiq:
          minReplicas: 1
          resources:
            limits:
              memory: 3G
            requests:
              cpu: 900m
              memory: 1G
        toolbox:
          backups:
            cron:
              enabled: true
              schedule: '@daily'
            objectStorage:
              config:
                key: config
                secret: s3cmd-config
          enabled: true
        webservice:
          extraEnv:
            GITLAB_LOG_LEVEL: debug
            HTTPS_PROXY: http://my-proxy.example.com:3210
            HTTP_PROXY: http://my-proxy.example.com:3210
            NO_PROXY: .example.com,localhost,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.svc.cluster.local
            http_proxy: http://my-proxy.example.com:3210
            https_proxy: http://my-proxy.example.com:3210
            no_proxy: .example.com,localhost,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.svc.cluster.local
          ingress:
            tls:
              secretName: gitlab-wildcard-tls
          minReplicas: 1
          monitoring:
            exporter:
              enabled: true
          puma:
            disableWorkerKiller: false
            workerMaxMemory: 2048
          resources:
            limits:
              memory: 4G
            requests:
              cpu: 1000m
              memory: 1G
          workhorse:
            resources:
              limits:
                memory: 100M
              requests:
                memory: 10M
      gitlab-runner:
        install: true
        rbac:
          create: false
        runners:
          cache:
            secretName: gitlab-minio-secret
          config: "[[runners]]\n  [runners.kubernetes]\n    image = \"registry-proxy.example.com/ubuntu:22.04\"\
            \n    pull_policy = \"if-not-present\"\n    allowed_pull_policies = [\"\
            if-not-present\", \"always\"]\n    memory_limit_overwrite_max_allowed\
            \ = \"32Gi\"\n    cpu_requests = \"400m\"\n    memory_requests = \"128Mi\"\
            \n    memory_limit = \"8Gi\"\n  [runners.cache]\n    Type = \"s3\"\n \
            \   Shared = true\n    [runners.cache.s3]\n      ServerAddress = \"minio.gitlab-object-storage.svc.cluster.local:9000\"\
            \n      BucketName = \"runner-cache\"\n      Insecure = true\n"
          runUntagged: true
          tags: dp,k8s,gitlab
        serviceAccountName: gitlab-gitlab-runner
      global:
        appConfig:
          artifacts:
            bucket: gitlab-artifacts
            connection: {}
            enabled: true
            proxy_download: true
          backups:
            bucket: gitlab-backups
            connection: {}
            tmpBucket: tmp
          ciSecureFiles:
            bucket: gitlab-ci-secure-files
            connection: {}
            enabled: true
          dependencyProxy:
            bucket: gitlab-dependency-proxy
            connection: {}
            enabled: true
            proxy_download: true
          externalDiffs:
            bucket: gitlab-mr-diffs
            connection: {}
            enabled: true
            proxy_download: true
          initialDefaults:
            signupEnabled: false
          lfs:
            bucket: git-lfs
            connection: {}
            enabled: true
            proxy_download: false
          object_store:
            connection:
              secret: gitlab-rails-storage
            enabled: true
            proxy_download: true
          omniauth:
            allowSingleSignOn:
            - openid_connect
            autoLinkUser:
            - openid_connect
            blockAutoCreatedUsers: false
            enabled: true
            externalProviders: []
            providers:
            - key: provider
              secret: gitlab-openid-connect
          packages:
            bucket: gitlab-packages
            connection: {}
            enabled: true
            proxy_download: true
          terraformState:
            bucket: gitlab-terraform-state
            connection: {}
            enabled: true
          uploads:
            bucket: gitlab-uploads
            connection: {}
            enabled: true
            proxy_download: true
        batch:
          cronJob:
            apiVersion: batch/v1
        hosts:
          domain: gitlab.in.example.com
          gitlab:
            name: gitlab.in.example.com
        hpa:
          apiVersion: autoscaling/v2
        ingress:
          annotations:
            cert-manager.io/cluster-issuer: production-issuer
          class: internal-nginx
          configureCertmanager: false
          tls:
            enabled: true
        kas:
          enabled: true
        minio:
          enabled: false
        pages:
          artifactsServer: true
          enabled: true
          host: pages.gitlab.in.example.com
          objectStore:
            bucket: gitlab-pages
            connection:
              secret: gitlab-rails-storage
            enabled: true
        pdb:
          apiVersion: policy/v1
        psql:
          database: gitlabhq_production
          host: pg-pgpool.gitlab-postgres.svc
          key: postgresql-password
          password:
            secret: gitlab-postgresql-password
            useSecret: true
          port: 5432
          username: postgres
        rails:
          bootsnap:
            enabled: false
        redis:
          host: mymaster
          password:
            enabled: false
          port: 6379
          sentinels:
          - host: redis.gitlab-redis.svc
            port: 26379
        registry:
          bucket: registry
      kas:
        metrics:
          enabled: true
      nginx-ingress:
        enabled: false
      postgresql:
        install: false
      prometheus:
        install: false
      redis:
        install: false
      registry:
        database:
          connecttimeout: 5s
          draintimeout: 2m
          enabled: false
          name: registry
          password:
            key: postgresql-password
            secret: gitlab-postgresql-password
          pool:
            maxidle: 25
            maxidletime: 5m
            maxlifetime: 5m
            maxopen: 25
          preparedstatements: true
          user: postgres
        debug:
          prometheus:
            enabled: true
        enabled: true
        hpa:
          minReplicas: 1
        ingress:
          tls:
            secretName: gitlab-registry-tls
        metrics:
          enabled: true
          serviceMonitor:
            enabled: false
        redis:
          cache:
            db: 1
            dialtimeout: 100ms
            enabled: false
            pool:
              idletimeout: 300s
              maxlifetime: 1h
              size: 10
            readtimeout: 100ms
            writetimeout: 100ms
        storage:
          key: config
          redirect:
            disable: true
          secret: registry-storage
      upgradeCheck:
        enabled: true
    instance_name: gitlab.in.example.com
    name: gitlab
    namespace: gitlab-server
    repo: https://charts.gitlab.io
    version: 6.8.3
  minio:
    chart_path: charts/minio/12.1.3
    fqdn: console.myvpc
    helm_values:
      auth:
        existingSecret: root-console-user
      extraEnvVars:
      - name: MINIO_PROMETHEUS_URL
        value: http://prometheus-operated.kube-infra.svc:9090
      - name: MINIO_PROMETHEUS_JOB_ID
        value: minio
      global:
        imageRegistry: image-proxy.example.com
      ingress:
        annotations:
          cert-manager.io/cluster-issuer: letsencrypt-production-issuer
        enabled: true
        hostname: console.myvpc.in.example.com
        ingressClassName: internal-nginx
        path: /
        tls: true
      metrics:
        serviceMonitor:
          enabled: true
          labels:
            release: kube-prometheus-stack
      mode: distributed
      persistence:
        enabled: true
        size: 32Gi
      podAnnotations:
        prometheus.io/path: /minio/v2/metrics/cluster
        prometheus.io/port: '9000'
        prometheus.io/scrape: 'true'
        release: kube-prometheus-stack
      provisioning:
        buckets:
        - name: registry
        - name: git-lfs
        - name: runner-cache
        - name: gitlab-uploads
        - name: gitlab-artifacts
        - name: gitlab-backups
        - name: gitlab-packages
        - name: tmp
        - name: gitlab-mr-diffs
        - name: gitlab-terraform-state
        - name: gitlab-ci-secure-files
        - name: gitlab-dependency-proxy
        - name: gitlab-pages
        enabled: true
        usersExistingSecrets:
        - centralized-minio-users
      serviceAccount:
        name: minio-sa
      statefulset:
        drivesPerNode: 2
        replicaCount: 8
        zones: 2
    name: minio
    namespace: gitlab-object-storage
    version: 12.1.3
docs:
- templates/docs/my_readme.md
domain: in.example.com
generators:
  manifest:
    default_config:
      annotations:
        manifests.kapicorp.com/generated: 'true'
      service_account:
        create: false
      type: job
kapitan:
  compile:
  - input_params:
      compile_path: /tmp/tmppj5qbj1b.kapitan/compiled/prd/.
    input_paths:
    - templates/docs/my_readme.md
    input_type: jinja2
    output_path: .
  - input_paths:
    - components/kubernetes
    input_type: kadet
    output_path: manifests
    output_type: yml
  - helm_params:
      name: gitlab
      namespace: gitlab-server
    helm_values:
      certmanager:
        install: false
      certmanager-issuer:
        email: sre@example.com
      gitlab:
        gitlab-shell:
          minReplicas: 1
        migrations:
          enabled: true
        sidekiq:
          minReplicas: 1
          resources:
            limits:
              memory: 3G
            requests:
              cpu: 900m
              memory: 1G
        toolbox:
          backups:
            cron:
              enabled: true
              schedule: '@daily'
            objectStorage:
              config:
                key: config
                secret: s3cmd-config
          enabled: true
        webservice:
          extraEnv:
            GITLAB_LOG_LEVEL: debug
            HTTPS_PROXY: http://my-proxy.example.com:3210
            HTTP_PROXY: http://my-proxy.example.com:3210
            NO_PROXY: .example.com,localhost,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.svc.cluster.local
            http_proxy: http://my-proxy.example.com:3210
            https_proxy: http://my-proxy.example.com:3210
            no_proxy: .example.com,localhost,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.svc.cluster.local
          ingress:
            tls:
              secretName: gitlab-wildcard-tls
          minReplicas: 1
          monitoring:
            exporter:
              enabled: true
          puma:
            disableWorkerKiller: false
            workerMaxMemory: 2048
          resources:
            limits:
              memory: 4G
            requests:
              cpu: 1000m
              memory: 1G
          workhorse:
            resources:
              limits:
                memory: 100M
              requests:
                memory: 10M
      gitlab-runner:
        install: true
        rbac:
          create: false
        runners:
          cache:
            secretName: gitlab-minio-secret
          config: "[[runners]]\n  [runners.kubernetes]\n    image = \"registry-proxy.example.com/ubuntu:22.04\"\
            \n    pull_policy = \"if-not-present\"\n    allowed_pull_policies = [\"\
            if-not-present\", \"always\"]\n    memory_limit_overwrite_max_allowed\
            \ = \"32Gi\"\n    cpu_requests = \"400m\"\n    memory_requests = \"128Mi\"\
            \n    memory_limit = \"8Gi\"\n  [runners.cache]\n    Type = \"s3\"\n \
            \   Shared = true\n    [runners.cache.s3]\n      ServerAddress = \"minio.gitlab-object-storage.svc.cluster.local:9000\"\
            \n      BucketName = \"runner-cache\"\n      Insecure = true\n"
          runUntagged: true
          tags: dp,k8s,gitlab
        serviceAccountName: gitlab-gitlab-runner
      global:
        appConfig:
          artifacts:
            bucket: gitlab-artifacts
            connection: {}
            enabled: true
            proxy_download: true
          backups:
            bucket: gitlab-backups
            connection: {}
            tmpBucket: tmp
          ciSecureFiles:
            bucket: gitlab-ci-secure-files
            connection: {}
            enabled: true
          dependencyProxy:
            bucket: gitlab-dependency-proxy
            connection: {}
            enabled: true
            proxy_download: true
          externalDiffs:
            bucket: gitlab-mr-diffs
            connection: {}
            enabled: true
            proxy_download: true
          initialDefaults:
            signupEnabled: false
          lfs:
            bucket: git-lfs
            connection: {}
            enabled: true
            proxy_download: false
          object_store:
            connection:
              secret: gitlab-rails-storage
            enabled: true
            proxy_download: true
          omniauth:
            allowSingleSignOn:
            - openid_connect
            autoLinkUser:
            - openid_connect
            blockAutoCreatedUsers: false
            enabled: true
            externalProviders: []
            providers:
            - key: provider
              secret: gitlab-openid-connect
          packages:
            bucket: gitlab-packages
            connection: {}
            enabled: true
            proxy_download: true
          terraformState:
            bucket: gitlab-terraform-state
            connection: {}
            enabled: true
          uploads:
            bucket: gitlab-uploads
            connection: {}
            enabled: true
            proxy_download: true
        batch:
          cronJob:
            apiVersion: batch/v1
        hosts:
          domain: gitlab.in.example.com
          gitlab:
            name: gitlab.in.example.com
        hpa:
          apiVersion: autoscaling/v2
        ingress:
          annotations:
            cert-manager.io/cluster-issuer: production-issuer
          class: internal-nginx
          configureCertmanager: false
          tls:
            enabled: true
        kas:
          enabled: true
        minio:
          enabled: false
        pages:
          artifactsServer: true
          enabled: true
          host: pages.gitlab.in.example.com
          objectStore:
            bucket: gitlab-pages
            connection:
              secret: gitlab-rails-storage
            enabled: true
        pdb:
          apiVersion: policy/v1
        psql:
          database: gitlabhq_production
          host: pg-pgpool.gitlab-postgres.svc
          key: postgresql-password
          password:
            secret: gitlab-postgresql-password
            useSecret: true
          port: 5432
          username: postgres
        rails:
          bootsnap:
            enabled: false
        redis:
          host: mymaster
          password:
            enabled: false
          port: 6379
          sentinels:
          - host: redis.gitlab-redis.svc
            port: 26379
        registry:
          bucket: registry
      kas:
        metrics:
          enabled: true
      nginx-ingress:
        enabled: false
      postgresql:
        install: false
      prometheus:
        install: false
      redis:
        install: false
      registry:
        database:
          connecttimeout: 5s
          draintimeout: 2m
          enabled: false
          name: registry
          password:
            key: postgresql-password
            secret: gitlab-postgresql-password
          pool:
            maxidle: 25
            maxidletime: 5m
            maxlifetime: 5m
            maxopen: 25
          preparedstatements: true
          user: postgres
        debug:
          prometheus:
            enabled: true
        enabled: true
        hpa:
          minReplicas: 1
        ingress:
          tls:
            secretName: gitlab-registry-tls
        metrics:
          enabled: true
          serviceMonitor:
            enabled: false
        redis:
          cache:
            db: 1
            dialtimeout: 100ms
            enabled: false
            pool:
              idletimeout: 300s
              maxlifetime: 1h
              size: 10
            readtimeout: 100ms
            writetimeout: 100ms
        storage:
          key: config
          redirect:
            disable: true
          secret: registry-storage
      upgradeCheck:
        enabled: true
    input_paths:
    - charts/gitlab/6.8.3
    input_type: helm
    output_path: gitlab
  - input_paths:
    - templates/docs/gitlab-values.yaml
    - templates/scripts/deploy.sh
    input_type: jinja2
    output_path: gitlab
  dependencies:
  - chart_name: gitlab
    output_path: charts/gitlab/6.8.3
    source: https://charts.gitlab.io
    type: helm
    version: 6.8.3
  target_full_path: prd
  vars:
    target: prd
target_name: prd

```