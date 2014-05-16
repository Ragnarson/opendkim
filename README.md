Description
===========

Opendkim cookbook with support for multiple domains.

Requirements
============

* Ubuntu / Debian

Attributes
==========

Usage
=====

Set _node[:opendkim][:domains]_ and include default recip into your code.

## Postfix integration (main.cf)

<pre># opendkim configuration
milter_default_action = accept
milter_protocol = 6
smtpd_milters = inet:<%= "#{node[:opendkim][:listen_host]}:#{node[:opendkim][:socket_port]}" %>
non_smtpd_milters = inet:<%= "#{node[:opendkim][:listen_host]}:#{node[:opendkim][:socket_port]}" %></pre>

## Key generation
1. Install _opendkim-tools_ locally or on server and execute
<pre>opendkim-genkey -s defa`ult -d \<fully fqdn\></pre>
for example:
<pre>opendkim-genkey -s default -d example.com</pre>
2. In result you will have two files _default.txt_ and _default.private_.
3. Encode both files via base64 and put it into cookbook attributes
<pre>default[:opendkim][:domains] = {
  "domain_name" => {
    "txt" => "txt_key", # base64 encoded
    "private" => "private_key" # base64 encoded
  }
}</pre>
to encode you may use _irb_
<pre>require 'base64'
Base64.encode64(File.open(\<path\>).read)
</pre>
4. From content of _default.txt_ create TXT record for domain.
<pre>default._domainkey.example.com. TXT	"\<default.txt content \>"</pre>
for example
<pre>default._domainkey.example.com. TXT	"v=DKIM1\; k=rsa\; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDZKy7zq5nd/v22BLwq27xSEjUA15lny3IqWypStOuZwKmO3nOVs0SBTIaZUuj4ChtCrL+INFuMCUicA80vua4OQ3spYFXdqjvi4flf/NK0FfJdNnOAeDAfjbEviP0wkPq5I5oqUIsn6Hgf16CDEgAjKYoFV6DcA/kbBzZDS6KRzQIDAQAB"</pre>
5. Run chef on affected servers.
6. Delete _default.txt_ and _default.private_.
