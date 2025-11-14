applications:
  platform-deployment:
    namespace: ${namespace}
    project: platform
    source:
      repoURL: ${artifact_repo_url}
      chart: ${artifact_chart}
      targetRevision: ${artifact_version}
      helm:
        passCredentials: true
        parameters:
          - name: "argocd.clusterName"
            value: "${cluster_name}"
          - name: "internalLbs"
            value: "${internal_lbs}"
          - name: "argocd.cluster"
            value: "${cluster_endpoint}"
          - name: "clusterType.deployment"
            value: "${deployment_cluster}"
          - name: "provider"
            value: "${provider}"
          - name: "harbor.enabled"
            value: "${harbor_enabled}"
          - name: "gitea.enabled"
            value: "${gitea_enabled}"
          - name: "platformConfig.enabled"
            value: "${platform_config_enabled}"
          - name: "externalDns.enabled"
            value: "${external_dns_enabled}"
          - name: "certManager.enabled"
            value: "${cert_manager_enabled}"
          - name: "harbor.registrySize"
            value: "${registry_size}"
          - name: "harbor.externalURL"
            value: "${harbor_url}"
          - name: "harbor.certManagerIssuer"
            value: "${harbor_cert_issuer}"
          - name: "gitea.certManagerIssuer"
            value: "${gitea_cert_issuer}"
          - name: "externalDns.stackit.project_id"
            value: "${try(stackit.project_id,"")}"
          - name: "externalDns.stackit.domain_filter"
            value: "${try(stackit.domain_filter,"")}"
          - name: "externalDns.stackit.auth_token"
            value: "${try(stackit.auth_token,"")}"
          - name: "dnsSuffix"
            value: "${try(dns_suffix,"")}"
          - name: "adminPassword"
            value: "${try(admin_password,"")}"
    destination:
      server: "https://kubernetes.default.svc"
      namespace: ${namespace}
    syncPolicy:
      automated:
        prune: true
        selfHeal: true
      syncOptions:
      - CreateNamespace=true
applicationsets:
%{ if platform_gitops_repo_url != "" }
  gitops-appset:
    namespace: ${namespace}
    project: platform
    additionalAnnotations: {}
    generators:
    - git:
        repoURL: ${platform_gitops_repo_url}
        revision: main
        files:
          - path: '**/config.yaml'
    template:
      metadata:
        name: '{{path.basename}}'
      spec:
        project: platform
        sources:
        - repoURL: '{{repoURL}}'
          targetRevision: '{{targetRevision}}'
          chart: '{{chart}}'
          helm:
            valueFiles:
            - $values/{{path.basename}}/values.yaml
        - repoURL: ${platform_gitops_repo_url}
          targetRevision: main
          path: '{{path.basename}}'
        - repoURL: ${platform_gitops_repo_url}
          targetRevision: main
          ref: values
        destination:
          name: '{{cluster}}'
          namespace: '{{path.basename}}'
        syncPolicy:
          automated: 
            selfHeal: true
          syncOptions:
            - CreateNamespace=true
            - ServerSideApply='{{serverSideApply}}'
%{ endif }
  platform-appset:
    namespace: ${namespace}
    project: platform
    additionalAnnotations: {}
    goTemplate: true
    goTemplateOptions: ["missingkey=error"]
    generators:
    - clusters:
        selector:
          matchLabels:
            argocd.argoproj.io/secret-type: "cluster"
    template:
      metadata:
        name: '{{.name}}-platform'
      spec:
        project: platform
        source:
           repoURL: ${artifact_repo_url}
           chart: ${artifact_chart}
           targetRevision: '{{index .metadata.annotations "aproject.net/platform-version"}}'
           helm:
             passCredentials: true
             parameters:
               - name: "argocd.clusterName"
                 value: "{{.name}}"
               - name: "argocd.cluster"
                 value: "{{.server}}"
               - name: "internalLbs"
                 value: "${internal_lbs}"
               - name: "provider"
                 value: "${provider}"
               - name: "externalDns.stackit.project_id"
                 value: "${try(stackit.project_id,"")}"
               - name: "externalDns.stackit.domain_filter"
                 value: "${try(stackit.domain_filter,"")}"
               - name: "externalDns.stackit.auth_token"
                 value: "${try(stackit.auth_token,"")}"
               - name: "dnsSuffix"
                 value: "{{.dnssuffix}}" #"${try(dns_suffix_workloads,"")}" 
        destination:
          server: "https://kubernetes.default.svc"
          namespace: ${namespace}
        syncPolicy:
          automated:
            prune: true
            selfHeal: true
          syncOptions:
          - CreateNamespace=true
projects:
  platform:
    namespace: ${namespace}
    description: Core Platform Components
    clusterResourceWhitelist:
    - group: '*'
      kind: '*'
    sourceRepos:
    - '*'
    destinations:
    - server: '*'
      namespace: '*'

%{ if platform_gitops_repo_url != "" }
itemTemplates:
- items:
    - name: gde
      url: ${platform_gitops_repo_url}
      password: ${platform_gitops_password}
      username: ${platform_gitops_login}  
  template:
    apiVersion: v1
    kind: Secret
    metadata:
      labels:
        argocd.argoproj.io/secret-type: repo-creds
      name: "argocd-credentials-template-{{ .name }}"
      namespace: ${namespace}
    stringData:
      password: "{{ .password }}"
      url: "{{ .url }}"
      username: "{{ .username }}"
%{ endif }
