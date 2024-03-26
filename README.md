# cloud_mesh
Supported providers
- aws
- azure
- exoscale
- gcp (not complete)
- linode
- vultr

## providers.yaml
Format of file. Add any providers you may have and specific them for first or second hop.
If more than one provider is listed then a selection will happen randomly from the list. 
```yaml
---
first_hop:
  - linode
  - aws
second_hop:
  - gcp
```

## keys.yaml
Format of file. Add any keys you may have.
```yaml
---
aws:
  access_key: 
  secret_key: 

digitalocean:
  key: 

linode:
  key: 

vultr:
  key: 

exoscale:
  access_key: 
  secret_key: 

```
## Run
```bash
python3 -m venv venv
source venv/bin/activate
python start.py
```
