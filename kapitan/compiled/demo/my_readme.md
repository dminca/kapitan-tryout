# My Readme

Target: demo

# INVENTORY

```
- common

```


```
_reclass_:
  environment: base
  name:
    full: demo
    short: demo
components:
  dbclean:
    config_maps:
      dbscript:
        data:
          script.sql:
            value: "-- drops all connections to the Database, to avoid this\n    \
              \  -- ERROR:  database \"gitlabhq_production\" is being accessed by\
              \ other users\n      -- DETAIL:  There are 8 other sessions using the\
              \ database.\n-- block connections\nREVOKE CONNECT ON DATABASE gitlabhq_production\
              \ FROM public;\n\n-- terminate existing connections\nSELECT\n      pg_terminate_backend(pg_stat_activity.pid)\n\
              FROM\n      pg_stat_activity\nWHERE\n      pg_stat_activity.datname\
              \ = 'gitlabhq_production'\nAND\n      -- except the current one\n  \
              \    pid <> pg_backend_pid();\n\n-- drop the Database\nDROP DATABASE\
              \ gitlabhq_production;\n\n-- re-create the Database\nCREATE DATABASE\
              \ gitlabhq_production OWNER postgres;\n\n-- unblock connections\nGRANT\
              \ CONNECT ON DATABASE gitlabhq_production TO public;\n"
        default_mode: 360
        mount: /tmp/script.sql
        subPath: script.sql
        versioned: true
    image: example.com/postgres:14.5-alpine
docs:
- templates/docs/my_readme.md
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
      compile_path: /tmp/tmppj5qbj1b.kapitan/compiled/demo/.
    input_paths:
    - templates/docs/my_readme.md
    input_type: jinja2
    output_path: .
  - input_paths:
    - components/kubernetes
    input_type: kadet
    output_path: manifests
    output_type: yml
  target_full_path: demo
  vars:
    target: demo
namespace: gitlab-postgres
target_name: demo

```