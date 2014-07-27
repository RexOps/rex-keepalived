global_defs {
  lvs_id <%= $lvs_id %>
}

vrrp_sync_group <%= $vrrp_sync_group_name %> {
  group {
    <% for my $vrrp_instance(@{ $vrrp_instances }) { %>
    <%= $vrrp_instance->{name} %>
    <% } %>
  }
}

<% for my $vrrp_instance (@{ $vrrp_instances }) { %>
vrrp_instance <%= $vrrp_instance->{name} %> {
  state <%= $vrrp_instance->{state} %>
  interface <%= $vrrp_instance->{interface} %>
  virtual_router_id <%= $vrrp_instance->{router_id} %>
  priority <%= $vrrp_instance->{priority} %>
  advert_int <%= $vrrp_instance->{advert_int} %>
  virtual_ipaddress {
    <% for my $vip (@{ $vrrp_instance->{virtual_ips} }) { %>
    <%= $vip->{ip} %>/<%= $vip->{cidr} %>
    <% } %>
  }
}

<% for my $vip (@{ $vrrp_instance->{virtual_ips} }) { %>
<% if( exists $vip->{real_servers} ) { %>
virtual_server <%= $vip->{ip} %> <%= $vip->{port} %> {
  delay_loop <%= $vip->{delay_loop} %>
  lb_algo <%= $vip->{lb_algo} %>
  lb_kind <%= $vip->{lb_kind} %>
  persistence_timeout <%= $vip->{persistence_timeout} %>
  protocol <%= $vip->{protocol} %>

  <% for my $server (@{ $vip->{real_server} }) { %>
  real_server <%= $server->{ip} %> <%= $vip->{port} %> {
    weight <%= $server->{weight} %>
    TCP_CHECK {
      connect_timeout 3
      connect_port 80
    }
  }
  <% } %>
}
<% } %>
<% } %>

<% } %>
