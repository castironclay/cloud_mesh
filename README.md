# cloud_mesh
Supported providers
- aws
- exoscale
- gcp 
- linode
- vultr
- digitalocean

## features
- randomized regions
- randomized providers
- multiple redirection methods

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

gcp:
  enabled: (true|false) # Creds file should be located within root of project named gcp_creds.json

exoscale:
  access_key: 
  secret_key: 

linode:
  key: 

vultr:
  key: 
```
## Run
```bash
python3 -m venv venv
source venv/bin/activate
python start.py
```
