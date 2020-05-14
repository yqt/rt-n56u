<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - <#menu5_16#></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<link rel="shortcut icon" href="images/favicon.ico">
<link rel="icon" href="images/favicon.png">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/main.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/engage.itoggle.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/bootstrap/js/engage.itoggle.min.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/itoggle.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>

<script type="text/javascript">
var $j = jQuery.noConflict(),
	IDX_CONFIG_NAME = 0,
	IDX_CONFIG_SERVER_ADDR = 1,
	IDX_CONFIG_SERVER_PORT = 2,
	IDX_CONFIG_PASSWORD = 3,
	IDX_CONFIG_METHOD = 4,
	CONFIG_KEY_LIST = [
		IDX_CONFIG_NAME,
		IDX_CONFIG_SERVER_ADDR,
		IDX_CONFIG_SERVER_PORT,
		IDX_CONFIG_PASSWORD,
		IDX_CONFIG_METHOD,
	],
	CONFIG_KEY_MAP = {
		'name': IDX_CONFIG_NAME,
		'addr': IDX_CONFIG_SERVER_ADDR,
		'port': IDX_CONFIG_SERVER_PORT,
		'pass': IDX_CONFIG_PASSWORD,
		'method': IDX_CONFIG_METHOD,
	},
	METHOD_MAP = {
		'none': 'none (ssr only)',
		'rc4': 'rc4',
		'rc4-md5': 'rc4-md5',
		'aes-128-cfb': 'aes-128-cfb',
		'aes-192-cfb': 'aes-192-cfb',
		'aes-256-cfb': 'aes-256-cfb',
		'aes-128-ctr': 'aes-128-ctr',
		'aes-192-ctr': 'aes-192-ctr',
		'aes-256-ctr': 'aes-256-ctr',
		'camellia-128-cfb': 'camellia-128-cfb',
		'camellia-192-cfb': 'camellia-192-cfb',
		'camellia-256-cfb': 'camellia-256-cfb',
		'bf-cfb': 'bf-cfb',
		'salsa20': 'salsa20',
		'chacha20': 'chacha20',
		'chacha20-ietf': 'chacha20-ietf',
		'aes-128-gcm': 'aes-128-gcm (ss only)',
		'aes-192-gcm': 'aes-192-gcm (ss only)',
		'aes-256-gcm': 'aes-256-gcm (ss only)',
		'chacha20-ietf-poly1305': 'chacha20-ietf-poly1305 (ss only)',
		'xchacha20-ietf-poly1305': 'xchacha20-ietf-poly1305 (ss only)'
	};

function parseConfigList(configListStr, configName) {
	try {
		configList = $j.parseJSON(configListStr.replace(/&#34;/g, '"'));
		return configList;
	} catch (e) {
		console.log(e);
	}
	return [];
}

function genMethodOptionsStr(method) {
	out = '';
	for (var k in METHOD_MAP) {
		out += '<option value="' + k + '" ' + (method == k ? 'selected' : '') +  '>' + METHOD_MAP[k] + '</option>';
	}
	return out;
}

function addServerNode(config, parentNode) {
	var htmlStr = '';

	htmlStr += '<td><input type="text" data-type="name" value="' + config[IDX_CONFIG_NAME] + '" /></td>';
	htmlStr += '<td><input type="text" data-type="addr" value="' + config[IDX_CONFIG_SERVER_ADDR] + '" /></td>';
	htmlStr += '<td><input type="text" data-type="port" value="' + config[IDX_CONFIG_SERVER_PORT] + '" /></td>';
	htmlStr += '<td><input type="password" data-type="pass" value="' + config[IDX_CONFIG_PASSWORD] + '" /></td>';
	// htmlStr += '<td><input type="text" data-type="method" value="' + config[IDX_CONFIG_METHOD] + '" /></td>';
	htmlStr += '<td><select data-type="method">' + genMethodOptionsStr(config[IDX_CONFIG_METHOD]) + '</select></tr>';
	htmlStr += '<td><input type="button" class="btn btn-info" value="<#CTL_del#>" onclick="deleteServer(this);"></td>';

	var trEle = document.createElement('tr');
	trEle.setAttribute('data-type', 'data_row')
	trEle.innerHTML = htmlStr;

	parentNode.append(trEle);
}

function getServerListFromTbody(tbodyEle) {
	var serverList = [];
	var serverNameMap = {};
	tbodyEle.find('tr[data-type="data_row"]').each(function() {
		var serverConf = getServerFromTr($j(this));
		if ($j.isEmptyObject(serverConf)) {
			return;
		}
		
		var serverName = serverConf[IDX_CONFIG_NAME];
		if (serverName in serverNameMap) {
			return;
		}
		serverNameMap[serverConf[IDX_CONFIG_NAME]] = 1;
		serverList.push(serverConf);
	})
	return serverList;
}

function getServerFromTr(trEle) {
	var serverConfMap = {};
	trEle.find('td>*[data-type]').each(function() {
		var $e = $j(this);
		var k = $e.data('type'),
			v = $e.val();
		if (k) {
			if (!v) {
				serverConfMap = {};
				return false;
			}
			serverConfMap[CONFIG_KEY_MAP[k]] = v;
		}
	});
	if ($j.isEmptyObject(serverConfMap)) {
		return [];
	}
	var serverConf = [];
	for (var i in CONFIG_KEY_LIST) {
		serverConf.push(serverConfMap[CONFIG_KEY_LIST[i]]);
	}
	return serverConf;
}

function addServer() {
	var serverTbodyEle = $j('#serverTable tbody');
	var serverConfig = getServerFromTr(serverTbodyEle.find('tr[data-type="preset_row"]'));
	if ($j.isEmptyObject(serverConfig)) {
		alert('invalid server config');
	} else {
		addServerNode(serverConfig, serverTbodyEle);
	}
}

function deleteServer(e) {
	$j(e).parents('tr').remove();
}

function applyServers() {
	var serverConfigList = getServerListFromTbody($j('#serverTable tbody'));
	showLoading();
	document.form.action_mode.value = " Apply ";
	document.form.current_page.value = "Shadowsocks_server_config.asp";
	document.form.next_page.value = "";
	document.form.ss_server_config.value = JSON.stringify(serverConfigList);
	document.form.submit();
}

function initial() {
	show_banner(2);
	show_menu(5,13,3);
	show_footer();

	var configListStr = '<% nvram_get_x("","ss_server_config"); %>';
	var configList = parseConfigList(configListStr);
	var serverTbodyEle = $j('#serverTable tbody');
	for (var i in configList) {
		addServerNode(configList[i], serverTbodyEle);
	}
}
</script>

<style>
.nav-tabs > li > a {
	padding-right: 6px;
	padding-left: 6px;
}
.table input, .table select {
	width: 100%;
}
.custom-center-line {
	text-align: center;
    margin-bottom: 10px;
}
</style>
</head>

<body onload="initial();" onunLoad="return unload_body();">
	<div class="wrapper">
		<div class="container-fluid" style="padding-right: 0px">
			<div class="row-fluid">
				<div class="span3"><center><div id="logo"></div></center></div>
				<div class="span9" >
					<div id="TopBanner"></div>
				</div>
			</div>
		</div>

		<div id="Loading" class="popup_bg"></div>

		<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
		<form method="post" name="form" id="serverConfigListForm" action="/start_apply.htm" target="hidden_frame">                                                               
			<input type="hidden" name="current_page" value="Shadowsocks.asp">        
			<input type="hidden" name="next_page" value="">                          
			<input type="hidden" name="next_host" value="">                          
			<input type="hidden" name="sid_list" value="ShadowsocksServers;">           
			<input type="hidden" name="group_id" value="">                           
			<input type="hidden" name="action_mode" value="">                        
			<input type="hidden" name="action_script" value="">
			<input type="hidden" name="ss_server_config" value="[]">
		</form>

		<div class="container-fluid">
			<div class="row-fluid">
				<div class="span3">
					<!--Sidebar content-->
					<!--=====Beginning of Main Menu=====-->
					<div class="well sidebar-nav side_nav" style="padding: 0px;">
						<ul id="mainMenu" class="clearfix"></ul>
						<ul class="clearfix">
							<li>
								<div id="subMenu" class="accordion"></div>
							</li>
						</ul>
					</div>
				</div>

				<div class="span9">
					<!--Body content-->
					<div class="row-fluid">
						<div class="span12">
							<div class="box well grad_colour_dark_blue">
								<h2 class="box_head round_top"><#menu5_16#></h2>
								<div class="round_bottom">
									<div class="row-fluid">
										<div id="tabMenu" class="submenuBlock"></div>
										<table id="serverTable" width="100%" cellpadding="4" cellspacing="0" class="table">
											<thead>
												<tr>
													<th><#Computer_Name#></th>
													<th><#menu5_16_4#></th>
													<th><#menu5_16_6#></th>
													<th><#menu5_16_5#></th>
													<th><#menu5_16_7#></th>
													<th></th>
												</tr>
											</thead>
											<tbody>
												<tr data-type="preset_row">
													<td><input type="text" data-type="name" value="" placeholder="required" /></td>
													<td><input type="text" data-type="addr" value="" placeholder="required" /></td>
													<td><input type="text" data-type="port" value="" placeholder="required" /></td>
													<!-- <td><input type="text" data-type="method" value="" /></td> -->
													<td><input type="password" data-type="pass" value="" placeholder="required" /></td>
													<td>
														<select data-type="method">
															<option value="none" >none (ssr only)</option>
															<option value="rc4" >rc4</option>
															<option value="rc4-md5" >rc4-md5</option>
															<option value="aes-128-cfb" >aes-128-cfb</option>
															<option value="aes-192-cfb" >aes-192-cfb</option>
															<option value="aes-256-cfb" >aes-256-cfb</option>
															<option value="aes-128-ctr" >aes-128-ctr</option>
															<option value="aes-192-ctr" >aes-192-ctr</option>
															<option value="aes-256-ctr" >aes-256-ctr</option>
															<option value="camellia-128-cfb" >camellia-128-cfb</option>
															<option value="camellia-192-cfb" >camellia-192-cfb</option>
															<option value="camellia-256-cfb" >camellia-256-cfb</option>
															<option value="bf-cfb" >bf-cfb</option>
															<option value="salsa20" >salsa20</option>
															<option value="chacha20" >chacha20</option>
															<option value="chacha20-ietf" >chacha20-ietf</option>
															<option value="aes-128-gcm" >aes-128-gcm (ss only)</option>
															<option value="aes-192-gcm" >aes-192-gcm (ss only)</option>
															<option value="aes-256-gcm" >aes-256-gcm (ss only)</option>
															<option value="chacha20-ietf-poly1305" >chacha20-ietf-poly1305 (ss only)</option>
															<option value="xchacha20-ietf-poly1305" >xchacha20-ietf-poly1305 (ss only)</option>
														</select>
													</td>
													<td><input type="button" class="btn btn-info" value="<#CTL_add#>" onclick="addServer();"></td>
												</tr>
												<tr>
													<td colspan="5"><span>servers below will be saved:</span></td>
												</tr>
											</tbody>
										</table>
									</div>
									<div class="row-fluid custom-center-line">
										<input class="btn btn-primary" type="button" value="<#CTL_apply#>" onclick="applyServers();">
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div id="footer"></div>
	</div>
</body>
</html>
