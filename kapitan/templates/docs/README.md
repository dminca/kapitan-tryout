{% set p = inventory.parameters %}
# {{p.target_name | upper }}

|||
| --- | --- |
| **Target** | {{ p.target_name }} |
| **Root domain**     | {% if p.domain is defined %} {{p.domain }} {% else %} 'Not defined' {% endif %} |
| **Namespace**   | `{{p.charts.gitlab.namespace}}` |

{% if p.charts is defined %}
## Helm Charts
| Chart template | Rendered manifests |
| --- | --- |
{% for chart in p.charts|sort %}
|[{{ chart }}](charts/{{ chart }})| [{{ chart }}](compiled/prd/{{ chart }})|
{% endfor %}
{% endif %}

## Deployments

