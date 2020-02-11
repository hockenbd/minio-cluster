Minio Cluster (Distributed Mode) Demonstration
===

Demonstration of Minio running in distributed mode using docker-compose and the AWS CLI as a S3 client.

Focus is on the AWS CLI behavior, read/write errors, and elapse time of operations when the Minio cluster is in different states (write quorum, read quorum, and failed cluster).

## Usage

```
$ ./test.sh
```

## Output

```bash
Generating test file...
1+0 records in
1+0 records out
1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.000859854 s, 1.2 GB/s

== Starting all nodes (write quorum) ==
Removing minio-cluster_node2_1 ... done
Removing minio-cluster_node4_1 ... done
Removing minio-cluster_node1_1 ... done
Removing minio-cluster_node3_1 ... done
Creating network "minio-cluster_default" with the default driver
Creating minio-cluster_node3_1 ... done
Creating minio-cluster_node2_1 ... done
Creating minio-cluster_node1_1 ... done
Creating minio-cluster_node4_1 ... done

>> successful bucket creation...
make_bucket: bucket1

>> successful bucket listing...
2020-02-10 23:37:18 bucket1

>> successful write...
Completed 256.0 KiB/1.0 MiB (17.0 MiB/s) with 1 file(s) remaining
Completed 512.0 KiB/1.0 MiB (32.2 MiB/s) with 1 file(s) remaining
Completed 768.0 KiB/1.0 MiB (46.2 MiB/s) with 1 file(s) remaining
Completed 1.0 MiB/1.0 MiB (59.0 MiB/s) with 1 file(s) remaining  
upload: ./zeros-1m.txt to s3://bucket1/zeros-1m-1.txt            

real	0m0.366s
user	0m0.316s
sys	0m0.024s

>> successful read...
Completed 256.0 KiB/1.0 MiB (29.9 MiB/s) with 1 file(s) remaining
Completed 512.0 KiB/1.0 MiB (55.7 MiB/s) with 1 file(s) remaining
Completed 768.0 KiB/1.0 MiB (80.9 MiB/s) with 1 file(s) remaining
Completed 1.0 MiB/1.0 MiB (104.9 MiB/s) with 1 file(s) remaining 
download: s3://bucket1/zeros-1m-1.txt to ./zeros-1m-1.txt        

real	0m0.336s
user	0m0.296s
sys	0m0.034s
====


== Stopping node 4 (n/2+1 remaining: write quorum) ==
minio-cluster_node4_1

>> successful write...
Completed 256.0 KiB/1.0 MiB (5.8 MiB/s) with 1 file(s) remaining
Completed 512.0 KiB/1.0 MiB (10.9 MiB/s) with 1 file(s) remaining
Completed 768.0 KiB/1.0 MiB (15.3 MiB/s) with 1 file(s) remaining
Completed 1.0 MiB/1.0 MiB (19.1 MiB/s) with 1 file(s) remaining  
upload: ./zeros-1m.txt to s3://bucket1/zeros-1m-2.txt            

real	0m0.458s
user	0m0.341s
sys	0m0.055s

>> successful read...
Completed 256.0 KiB/1.0 MiB (32.7 MiB/s) with 1 file(s) remaining
Completed 512.0 KiB/1.0 MiB (60.5 MiB/s) with 1 file(s) remaining
Completed 768.0 KiB/1.0 MiB (88.0 MiB/s) with 1 file(s) remaining
Completed 1.0 MiB/1.0 MiB (113.2 MiB/s) with 1 file(s) remaining 
download: s3://bucket1/zeros-1m-2.txt to ./zeros-1m-2.txt        

real	0m0.339s
user	0m0.312s
sys	0m0.020s
====


== Stopping node 3 (n/2 remaining: read quorum) ==
minio-cluster_node3_1

>> failed write...
Completed 256.0 KiB/1.0 MiB (253.0 KiB/s) with 1 file(s) remaining
Completed 512.0 KiB/1.0 MiB (505.0 KiB/s) with 1 file(s) remaining
Completed 768.0 KiB/1.0 MiB (756.3 KiB/s) with 1 file(s) remaining
Completed 1.0 MiB/1.0 MiB (1006.8 KiB/s) with 1 file(s) remaining 
upload failed: ./zeros-1m.txt to s3://bucket1/zeros-1m-3.txt Read timeout on endpoint URL: "http://localhost:9000/bucket1/zeros-1m-3.txt"

real	5m9.651s
user	0m0.368s
sys	0m0.062s

>> successful read...
Completed 256.0 KiB/1.0 MiB (37.1 MiB/s) with 1 file(s) remaining
Completed 512.0 KiB/1.0 MiB (36.6 MiB/s) with 1 file(s) remaining
Completed 768.0 KiB/1.0 MiB (52.3 MiB/s) with 1 file(s) remaining
Completed 1.0 MiB/1.0 MiB (66.5 MiB/s) with 1 file(s) remaining  
download: s3://bucket1/zeros-1m-2.txt to ./zeros-1m-2-2.txt      

real	0m0.351s
user	0m0.306s
sys	0m0.036s
====


== Stopping node 2 (n/2-1 remaining: failed cluster) ==
minio-cluster_node2_1

>> failed write...
Completed 256.0 KiB/1.0 MiB (253.3 KiB/s) with 1 file(s) remaining
Completed 512.0 KiB/1.0 MiB (505.6 KiB/s) with 1 file(s) remaining
Completed 768.0 KiB/1.0 MiB (757.5 KiB/s) with 1 file(s) remaining
Completed 1.0 MiB/1.0 MiB (1008.7 KiB/s) with 1 file(s) remaining 
upload failed: ./zeros-1m.txt to s3://bucket1/zeros-1m-4.txt Read timeout on endpoint URL: "http://localhost:9000/bucket1/zeros-1m-4.txt"

real	5m13.314s
user	0m0.368s
sys	0m0.062s

>> failed read...
fatal error: Read timeout on endpoint URL: "http://localhost:9000/bucket1/zeros-1m-2.txt"

real	5m9.129s
user	0m0.318s
sys	0m0.029s
====


== Restarting all cluster nodes (write quorum) ==
Stopping minio-cluster_node1_1 ... done
Stopping minio-cluster_node1_1 ... done
Removing minio-cluster_node1_1 ... done
Removing minio-cluster_node4_1 ... done
Removing minio-cluster_node3_1 ... done
Removing minio-cluster_node2_1 ... done
Removing minio-cluster_node1_1 ... done
Removing network minio-cluster_default
Creating network "minio-cluster_default" with the default driver
Creating minio-cluster_node3_1 ... done
Creating minio-cluster_node2_1 ... done
Creating minio-cluster_node4_1 ... done
Creating minio-cluster_node1_1 ... done

>> successful write...
Completed 256.0 KiB/1.0 MiB (22.0 MiB/s) with 1 file(s) remaining
Completed 512.0 KiB/1.0 MiB (41.6 MiB/s) with 1 file(s) remaining
Completed 768.0 KiB/1.0 MiB (59.6 MiB/s) with 1 file(s) remaining
Completed 1.0 MiB/1.0 MiB (76.2 MiB/s) with 1 file(s) remaining  
upload: ./zeros-1m.txt to s3://bucket1/zeros-1m-5.txt            

real	0m0.393s
user	0m0.324s
sys	0m0.032s

>> successful read...
Completed 256.0 KiB/1.0 MiB (30.5 MiB/s) with 1 file(s) remaining
Completed 512.0 KiB/1.0 MiB (56.8 MiB/s) with 1 file(s) remaining
Completed 768.0 KiB/1.0 MiB (82.8 MiB/s) with 1 file(s) remaining
Completed 1.0 MiB/1.0 MiB (107.6 MiB/s) with 1 file(s) remaining 
download: s3://bucket1/zeros-1m-5.txt to ./zeros-1m-5.txt        

real	0m0.343s
user	0m0.321s
sys	0m0.016s
====
```
