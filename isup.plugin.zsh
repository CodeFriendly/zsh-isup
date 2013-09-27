#!/bin/zsh

# usage: isup [host]
function isup() {
	emulate -L zsh
	autoload colors
	[[ $terminfo[colors] -ge 8 ]] && colors

	local host hosts TIMEFMT out nslookup http_code dns_time req_time bell

	bell=0

	if [[ ! -z "$1" ]]; then
		hosts=$1
	else
		if [[ ! -e ~/.isuprc ]]; then
			print Creating $HOME/.isuprc...
			cp ${0:h}/isuprc.example ~/.isuprc
		fi

		. ~/.isuprc
	fi

	TIMEFMT='%*E'

	print "Status     DNS   REQ   Domain"
	for host in $hosts; do
		out=(${(s/ /)"$(curl -L -w '%{http_code} %{time_total} %{time_namelookup} %{time_connect} %{time_appconnect} %{time_pretransfer} %{time_redirect} %{time_starttransfer}' -so/dev/null --connect-timeout 5 $host)"})

		http_code=$out[1]
		dns_time=$out[3]
		req_time=$(printf '%.3f' $(($out[2] - $out[3])))

		if [[ $http_code -eq 000 ]]; then
			http_code=${$(nslookup $host | grep NXDOMAIN >/dev/null && print 105):-405}
		fi

		if [[ $http_code -eq 200 && $req_time -lt 5 ]]; then
			print "[$fg_bold[green]pass$reset_color] $http_code $dns_time $req_time $host"
		else
			[[ $bell -ne 0 ]] && print -n 
			print "[$fg_bold[red]fail$reset_color] $fg_bold[yellow]$http_code $dns_time $req_time $fg_bold[white]$host$reset_color"
		fi
	done
}
