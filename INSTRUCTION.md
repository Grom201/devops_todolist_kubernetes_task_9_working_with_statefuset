# Kubernetes StatefulSet Validation Guide

## Prerequisites

* Docker installed
* kind installed
* kubectl installed

---

## Create the cluster

```bash
./bootstrap.sh
```

or manually:

```bash
kind create cluster --config cluster.yml
```

---

## Verify Namespaces

```bash
kubectl get namespaces
```

Expected namespaces:

```text
mysql
todoapp
```

---

## Verify MySQL StatefulSet

```bash
kubectl get statefulsets -n mysql
```

Expected output:

```text
NAME    READY   AGE
mysql   3/3
```

---

## Verify MySQL Pods

```bash
kubectl get pods -n mysql
```

Expected output:

```text
mysql-0   Running
mysql-1   Running
mysql-2   Running
```

---

## Verify Headless Service

```bash
kubectl get svc -n mysql
```

Expected output:

```text
NAME    TYPE        CLUSTER-IP   PORT(S)
mysql   ClusterIP   None         3306/TCP
```

The Service must have:

```text
CLUSTER-IP = None
```

which confirms that it is a Headless Service.

---

## Verify Persistent Volume Claims

```bash
kubectl get pvc -n mysql
```

Expected:

```text
mysql-data-mysql-0
mysql-data-mysql-1
mysql-data-mysql-2
```

All PVCs should be in the Bound state.

---

## Verify MySQL Initialization

Connect to the first MySQL pod:

```bash
kubectl exec -it mysql-0 -n mysql -- bash
```

Login to MySQL:

```bash
mysql -uroot -p
```

Enter the root password from the Secret.

Check databases:

```sql
SHOW DATABASES;
```

Expected database:

```text
todo
```

This confirms that init.sql was executed successfully.

---

## Verify Application Deployment

```bash
kubectl get deployment -n todoapp
```

Expected:

```text
todoapp
```

Verify pods:

```bash
kubectl get pods -n todoapp
```

Expected:

```text
STATUS = Running
READY = 1/1
```

---

## Verify Database Connection Settings

Check application environment variables:

```bash
kubectl exec -it <todoapp-pod-name> -n todoapp -- env | grep DB
```

Expected variables:

```text
DB_NAME
DB_USER
DB_PASSWORD
DB_HOST
```

Expected host:

```text
mysql-0.mysql
```

---

## Verify Application Availability

Get service information:

```bash
kubectl get svc -n todoapp
```

Access the application through the exposed service and verify that the application is reachable.

---

## Cleanup

Delete the cluster:

```bash
kind delete cluster
```
