# cloud_mesh
Supported providers
- aws
- azure
- exoscale
- gcp (not complete)
- linode
- vultr

## providers.yaml
Format of file. Add any providers you may have.
```yaml
---
- linode
- vultr
- exoscale
- aws
- azure
```

## keys.yaml
Format of file. Add any keys you may have.
```yaml
---
aws:
  access_key: 
  secret_key: 

linode:
  key: 

vultr:
  key: 

exoscale:
  access_key: 
  secret_key: 

azure:
  app_client_id: 
  tenant: 
  secret: 
  sub_id: 
```
## Run
python3 -m venv venv
source venv/bin/activate
python start.py
