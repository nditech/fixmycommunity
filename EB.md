# Deploy to ElasticBeanstalk
## Development Workflow

### Workflow Process

### Clone Project Repository
`git clone --recursive https://github.com/nditech/fixmystreet

### Create ElasticBeanstalk Environment
```eb create```

### Deploy Application to Staging Environment
```git checkout staging```
```eb init```
```eb init --profile nditech```
```eb use stg```
```eb deploy```
