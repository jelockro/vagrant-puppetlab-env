while [ "`runlevel`" = "unknown" ]; do
    echo "runlevel is 'unknown' - waiting for 10s"
    sleep 10
done
echo "runlevel is now valid ('`runlevel`'), kicking off provisioning..."