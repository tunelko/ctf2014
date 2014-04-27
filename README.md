**Generate aws credentials and save rootkey.csv to aws/**
```
Checkout AWS docs, must be done through browser.
```

**Create the cloud**
```
aws/create
```

**Get partial status**
```
aws/status
```

**Create systems**
```
vagrant up
```

**Get a full status**
```
aws/status
```

Note the ip address of the t1 box, this is where you can start.

**Stop systems**
```
vagrant halt
```

**Destroy systems**
```
vagrant destroy -f
```

**Destroy Cloud**
```
aws/destroy
```
