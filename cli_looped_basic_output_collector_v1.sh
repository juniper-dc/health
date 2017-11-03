#!/bin/sh
#Michal#Styszynski#JUNIPER#NETWORKS#PS#EMEA
#basic shell loop for junos commands
mystarttime=`date +%H_%M_%S`
myday=`date +%F`
LINE_SEP="================================================================\
==========="


if [ -d /var/tmp/jnpr_data ]; then
	rm -r /var/tmp/jnpr_data
fi

mkdir /var/tmp/jnpr_data
cd /var/tmp/jnpr_data
echo == start collecting the junos outputs $myday $mystarttime == 



COUNTER=0
while [  $COUNTER -lt 100 ]; do
	echo ${LINE_SEP}
	myday=`date +%F`
	mystarttime=`date +%H_%M_%S`
	let COUNTER=COUNTER+1
	echo junos outputs collection number $COUNTER started $myday $mystarttime
	echo ${LINE_SEP}
	cli -c "show system processes extensive | except 0.00" >> show_system_processes_ext_expect_00_$mystarttime
	cli -c "show chassis fpc" >> show_chassis_fpc_$mystarttime
	cli -c "show chassis routing-engine" >> show_chassis_routing-engine_$mystarttime
	cli -c "show system virtual-memory" >> sh_system_virtual_memory_first_$mystarttime
	cli -c "show task io" >> show_task_io_$mystarttime
	cli -c "show task memory" >> show_task_memory_$mystarttime
	cli -c "show system kernel memory" >> show_system_kernel_memory_$mystarttime
	cli -c "show system statistics" >> show_system_statistics_$mystarttime
	cli -c "show system queues | no-more" >> show_system_queues_$mystarttime
	cli -c "show task statistics " >> show_task_statistics_$mystarttime
	cli -c "show task io" >> show_task_io_$mystarttime
	cli -c "show krt queue  | no-more" >> show_krt_queue_$mystarttime
	cli -c "show krt state  | no-more" >> show_krt_state_$mystarttime
	sleep 5s
done
cli -c "show configuration system host-name" >> myhostname
cli -c "show route summary  | no-more" >> show_route_summary_$mystarttime
cli -c "show log messages | no-more" >> show_log_messages_$mystarttime
cli -c "show configuration | display set | no-more" >> show_configuration_display_set_$mystarttime

y=`date +%F`
t=`date +%H_%M_%S`
tar -zcf /var/tmp/jnpr_data.tgz -C /var/tmp/jnpr_data/ *
mv /var/tmp/jnpr_data.tgz /var/tmp/jnpr_data_$y"_"$t.tgz
rm -r /var/tmp/jnpr_data

echo "=============voila=================="
echo "== please download the following files =="
echo "===================================="
ls -lrt /var/tmp/jnpr*
