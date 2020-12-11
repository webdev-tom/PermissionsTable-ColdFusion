<!doctype html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Permission Table Demo | tomfafard.com</title>

<link href="/includes/plugins/bootstrap3/css/bootstrap.css" rel="stylesheet">
<link href="/includes/plugins/sumoselect/sumoselect.min.css" rel="stylesheet">
<link href="/includes/plugins/fontawesome/css/all.min.css" rel="stylesheet">
<style>
	
	body{
		background-color: #fefefe;
	}
	
	table#permissionTable{
		margin: 0 auto;
		width: 100%;
		clear: both;
		border-collapse: collapse;
		table-layout: fixed; 
		word-wrap:break-word; 
	}
/*
	
	table.dataTable thead th, 
	table.dataTable thead td{
		border-bottom: 1px solid #448AC8 !important;
	}
	
	.dataTables_wrapper.no-footer .dataTables_scrollBody{
		border-bottom: 2px solid #448AC8 !important;
	}
	
	.dataTables_filter{
	   float: left !important;
	}
	
	.dataTables_wrapper .dataTables_filter input {
		margin-left: 0 !important;
	}
	
*/
	
	.nopadding{
		padding: 0 !important;
	}
	
	.blockRow {
		display: block !important;
	}
	
	
	.loader{
		margin-top: 50px;
		text-align: center;
		font-size: 1.5em;
		transition: 500ms ease;
		opacity: 0;
		display: none;
		vertical-align: middle;
		user-select: none;
		cursor: default;
	}
	
	.smoothFade{
		transition: opacity 500ms ease;
	}
	
	.smoothSlide{
		transition: 500ms ease;
	}
	
	
	.statusNav {
		display: inline-flex;
		justify-content: center;
	}

	.pPill{
		padding: 0 3px;
		width: calc(100% / 3) !important;
	}
	.pPill a{
		border: 1px solid #448AC8 !important;
	}
	
	.pTable {
		width: 99%;
	}
	
	.pTitle {
		background-color: #F5FBFF;
		font-weight: bold;
	}
	
	.list-group-item{
		transition: 150ms ease;
	}
	
	.userColCell{
		text-align: center;
	}
	
	.submitChangesBtn{
		display: inline-block;
		color: #78B99A;
		margin-left: 5px;
		position: absolute;
		right: 0;
		top: 0;
		height: 100%;
		padding: 0 12px !important;
		background-color: rgba(255,255,255,0) !important;
	}
	
	.discardChangesBtn{
		display: inline-block;
		color: #E95671;
		margin-right: 5px;
		position: absolute;
		left: 0;
		top: 0;
		height: 100%;
		padding: 0 12px !important;
		background-color: rgba(255,255,255,0) !important;
	}
	
	.submitChangesBtn:hover, 
	.discardChangesBtn:hover{
/*		border: 1px solid #A9A9A9;*/
		border: none;
		color: #AFC3D1;
	}
	
	.colDisplayName{
		width: 50%;
		margin: 0 auto !important;
	}


	
	
	#userSelectContainer{
		height: 100vh;
		background-color: #ebebeb;
		padding: 25px;
	}
	
	#usl-container{
		background-color: #fff;
		border: 1px solid #448AC8;
		border-radius: 4px;
		margin-top: 5px;
		height: 80%;
		overflow: scroll;
	}
	
	#user-select-list{
		margin-bottom: 0 !important;
		transition: 500ms ease;
		opacity: 0;
		display: none;
	}
	
	#deselectBtn{
		font-weight: bold;
		width: 100%;
		margin-top: 4px;
		opacity: 0.3;
		transition: opacity 200ms ease-in;
	}
	
	#appHint{
		width: 100%;
		text-align: center;
		position: absolute;
		top: 40%;
		left: 0;
		transition: opacity 150ms ease;
		z-index: 1;
	}
	
	#appHint h2{
		color: #4D4D4D;
		user-select: none;
		-webkit-user-select: none;
		cursor: default;
	}

	#permissionTableContainer {
		padding: 14px 35px;
	}
	
	#permissionTable tbody{
		display:block;
		overflow:auto;
		height:80vh;
		width:100%;
		border-bottom: 2px solid #BEBEBE;
	}
	
	#permissionTable thead{
		border-bottom: 2px solid #BEBEBE;
	}
	
	#permissionTable thead tr{
		display:block;
		transition: height 500ms ease;
		height: 0;
		opacity: 0;
	}
	
	#permissionTable thead th,
	#permissionTable thead td{
		padding: 10px 18px;
	}
	
	#permissionTable tbody td{
		padding: 8px 10px;
		vertical-align: middle;
	}

	#toggleLeftHandView {
		 position: absolute;
		 font-size: 2em;
		 top: 0;
		 left: 10px;
		 cursor: pointer;
		 z-index: -1;
	 }


	/* SumoSelect Overrides */

	.SumoSelect > .CaptionCont > span {
		padding-right: 0 !important;
	}



	@media only screen and (max-width: 992px) {
		.leftHandView {
			transform: translate3d(-100%,0,0);
			position: absolute;
			transition: 400ms ease;
			z-index: 10;
		}

		.rightHandView {
			margin-top: 30px;
		}

		#toggleLeftHandView {
			z-index: 2;
		}

		#userSelectContainer {
			padding: 0 25px 25px 25px;
		}

		#usl-container{
			height: 60%;
		}

		#permissionTableContainer {
			padding: 14px 0px;
		}

		#permissionTable tbody{
			height:65vh;
		}
	}

	
</style>
</head>
<body>

	
<cfoutput>

	<div id="toggleLeftHandView"><i class="fas fa-bars"></i></div>
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-3 nopadding leftHandView">
				
				<div id="userSelectContainer">
					<ul class="nav nav-pills nav-justified statusNav">
						<li role="presentation" class="pPill"><a href="##" onClick="checkRefreshList(this)" data-flag="ALL">All</a></li>
						<li role="presentation" class="pPill active"><a href="##" onClick="checkRefreshList(this)" data-flag="1">Active</a></li>
						<li role="presentation" class="pPill"><a href="##" onClick="checkRefreshList(this)" data-flag="0">Inactive</a></li>
					</ul>
					<div id="usl-container">
						<div class="loader"><i class="fas fa-sync-alt fa-spin"></i><br>Updating user list...</div>
						<div class="list-group" id="user-select-list"></div>
					</div>
					<button id="deselectBtn" class="btn btn-primary" onClick="removeSelection()" disabled>Clear Selection</button>

					<!---<br><br><br>--->
					<!---<strong style="font-size: 20px;">User Array = <span id="testArrayValue">[]</span></strong>--->

				</div>
			</div>
			<div class="col-md-9 nopadding rightHandView">
				<div id="permissionTableContainer">
					<div id="appHint"><h2>Select a user from the list to edit their permissions.</h2></div>
					<table border="0" class="pTable" id="permissionTable">
						<thead>
							<tr></tr>
						</thead>
						<tbody></tbody>
					</table>
				</div><!--- table container --->

			</div><!--- col-md-9 --->
		</div><!--- row --->
	</div>
	

	

	

</cfoutput>
<script src="/includes/plugins/jquery_3.4.1/jquery-3.4.1.min.js" type="text/javascript"></script>
<script src="/includes/plugins/bootstrap3/js/bootstrap.min.js" type="text/javascript"></script>
<script src="/includes/plugins/fontawesome/js/all.min.js" type="text/javascript"></script>
<script src="/includes/plugins/sumoselect/jquery.sumoselect.min.js" type="text/javascript"></script>
<script type="text/javascript">
$(function(){

	//init user-select-list
	let initUserList = refreshUserList(1);

	//define changes array, which records the permission changes we'll need to make
	let changes = [];

	//define global selectedUsers array, which holds the users we'll go and grab
	window.selectedUsers = [];

	//define global tableParams object for dynamic datatable creation
	window.tableParams = {
		paging: false,
		sort: false,
		scrollY: "80vh",
		info: false,
		language: {
    		"search": "Filter permissions: "
  		},
		initComplete : function() {
        	//$("#permissionTable_filter").detach().appendTo('#searchArea');
			$("#permissionTable_filter").find('label').css("text-align","left");
			$("#permissionTable_filter").find('input').addClass('form-control');
    	}
	}


	// handle panel for mobile
	$('#toggleLeftHandView').on('click',function(){
		$('.leftHandView').css('transform','translate3d(0,0,0)');
		$('.rightHandView').one('click',function(){
			$('.leftHandView').css('transform','translate3d(-100%,0,0)');
		});
	});


	
	
	
	
//	setTimeout(function(){
//		getUserCol('TFAFARD');
//	},5000);
	
	
	
	
	//init dataTable
	//$('#permissionTable').dataTable(tableParams);
	
	
	
});
	
	

function getForms() {
	
	return new Promise(resolve => {
		
		try {
			$.ajax({
				type: "get",
				url: "permissions_CFC.cfc?method=getForms",
				dataType: "text",
				cache: false,
				success: function( data ){
					let json = data.trim();
					let objRes = JSON.parse(json);
					if(objRes.status == 'pass'){
						let formObjArr = objRes.json_result;

						let formsObj = {};
						for(let i = 0; i < formObjArr.length; i++){
							formsObj[formObjArr[i].FORMID] = formObjArr[i].FORMTITLE;
						}

						resolve(formsObj);

					} else {
						alert(objRes.reason);
						resolve(false);
					}

				}
			});	
		}
		catch(err) {
			alert(err);
			resolve(false);
		}
		
	});

	
	
}

	
	
	
function checkRefreshList(e) {
	
	let $thisPillLink = $(e);
	let $thisPill = $(e).parent('li');
	let $thisPillGroup = $(e).parent('li').parent('ul');

	if(!$thisPill.hasClass('active')){
		$thisPillGroup.children('li').each(function(){
			$(this).removeClass('active');
		});
		$thisPill.addClass('active');
		refreshUserList($thisPillLink.data('flag'));
	}
}


	
	
function refreshUserList(activeFlag) {

	$('#user-select-list').css("opacity","0");
	setTimeout(function(){
		$('.loader').show();
		$('#user-select-list').hide();
		$('.loader').css("opacity","1");
		$('#user-select-list').html('');


		if(typeof activeFlag == 'undefined'){
			activeFlag = 'ALL'
		}

		const maxselectedusers = 3;
		$.ajax({
			type: "get",
			url: "permissions_CFC.cfc?method=getUsers",
			dataType: "text",
			data: {
				activationStatus: activeFlag
			},
			cache: false,
			success: function( data ){
				let json = data.trim();
				let objRes = JSON.parse(json);
				
				if(objRes.status == 'pass'){

					let userObjArr = objRes.json_result;

					for(let i = 0; i < userObjArr.length; i++){
						$('#user-select-list').append('<a href="##" class="list-group-item' + ((selectedUsers.indexOf(parseInt(userObjArr[i].LOGON_ID)) > -1) ? ' active' : '') + '" title="' + userObjArr[i].LOGON_USER + '" data-userid="' + userObjArr[i].LOGON_ID + '" data-logonuser="' + userObjArr[i].LOGON_USER + '">' + userObjArr[i].LOGON_NAME + '</a>');
					}


					$('#user-select-list').children('a').each(function(){
						$(this).on('click',function(){
							if($(this).hasClass('active')){

								selectedUsers = spliceArray(selectedUsers,$(this).data('userid'));

								removeUserCol($(this).data('logonuser'),$(this).data('userid'));

								$(this).removeClass('active');

							} else {

								if(selectedUsers.length < maxselectedusers){

									$(this).addClass('active');

									selectedUsers.push($(this).data('userid'));

									getUserCol($(this).data('logonuser'),$(this).html(),$(this).data('userid'));

								} else {
									//selected user limit reached, do nothing...
								}


							}

							if(selectedUsers.length > 0){
								$('#deselectBtn').prop('disabled',false);
								$('#deselectBtn').css("opacity","1");
							} else {
								$('#deselectBtn').prop('disabled',true);
								$('#deselectBtn').css("opacity","0.3");
							}


							//visual testing ( testArrayValue )
							// let visualArrayStr = '[';
							// for(let i=0;i<selectedUsers.length;i++){
							// 	visualArrayStr += (selectedUsers[i] + ', ')
							// }
							//
							// if(selectedUsers.length > 0){
							// 	visualArrayStr = visualArrayStr.slice(0, -2);
							// }
							// visualArrayStr += ']';
							//
							// $('#testArrayValue').html(visualArrayStr);

						});
					});




					$('#user-select-list').show();
					$('.loader').css("opacity","0");
					setTimeout(function(){
						$('.loader').hide();
						$('#user-select-list').css("opacity","1");



						//console.dir($._data($('.list-group-item').get(0), "events"));

					},500);

				} else {
					alert(objRes.reason);
					return false;
				}

			}
		});	
		
	},500);

}
	
	
	
	

function getUserCol(logon_user,logon_name,logon_id) {
	
	let save_logon_user = logon_user;
	
	//object to save original permissions object, in case user wishes to revert changes they made
	let orig_permissions = {};

	$.ajax({
		type: "get",
		url: "permissions_CFC.cfc?method=getUserCol",
		dataType: "text",
		data: {
			LOGON_USER: logon_user,
			USER_ID: logon_id
		},
		cache: false,
		success: function( data ){
			let json = data.trim();
			let objRes = JSON.parse(json);

			if(objRes.status == 'pass'){

				let logon_user = objRes.json_result.LOGON_USER;
				let pObjArr = objRes.json_result.PERMISSIONS;
				
				orig_permissions[logon_user] = pObjArr;


				let tableW = $('#permissionTable').outerWidth();
				let checkTHead = $('#permissionTable > thead > tr').children();

				if(checkTHead.length){
					//column header exists, don't worry about form labels column

					let colWidth = getColWidth(tableW,checkTHead.length);

					addUserCol(logon_user,pObjArr,orig_permissions,logon_name,logon_id)
					.then(result => adjColWidth(colWidth))
					.then(function(){
						$('#permissionTable > thead > tr').find('th:last-child').css('opacity',1);
						$('#permissionTable > tbody').find('tr > td:last-child').css('opacity',1);
					});

				} else {
					//column header does not exist, create form labels column

					let colWidth = getColWidth(tableW,2);

					$('#appHint').css({'opacity':'0','z-index':'-1'});
					$('#permissionTable > thead > tr').css({'height':'42px'});
					$('#permissionTable > thead').css('border-bottom','2px solid #448AC8');
					$('#permissionTable > tbody').css('border-bottom','2px solid #448AC8');
					setTimeout(function(){
						$('#permissionTable > thead > tr').append('<th class="smoothSlide">&nbsp;</th>');

						getForms().then(function(result){
							return new Promise(resolve => {
								let formsArr = Object.entries(result);

								for(let i = 0; i < formsArr.length; i++){
									$('#permissionTable > tbody').append('<tr class="smoothFade" style="opacity:0"><td class="pTitle" data-formid="' + formsArr[i][0] + '">' + formsArr[i][1] + '</td></tr>');
								}	

								resolve(true);
							});
						})
						.then(result => addUserCol(logon_user,pObjArr,orig_permissions,logon_name,logon_id))
						.then(result => adjColWidth(colWidth))
						.then(function(){
							$('#permissionTable > thead > tr').find('th:last-child').css('opacity',1);
							$('#permissionTable > tbody').find('tr > td:last-child').css('opacity',1);
							setTimeout(function(){
								$('#permissionTable > thead').find('tr').css('opacity',1);
								$('#permissionTable > tbody').find('tr').css('opacity',1);
							},500)
						});
					},500);
					
				}


			} else {
				
				let $userToDeselect = $('#user-select-list').find('[data-logonuser="' + save_logon_user + '"]');
				
				alert(objRes.reason);
				
				selectedUsers = spliceArray(selectedUsers,$userToDeselect.data('userid'));
				$userToDeselect.removeClass('active');
				return false;
			}
		}
	});	

}
	

function addUserCol(logon_user,pObjArr,orig_permissions,logon_name,logon_id){
	return new Promise(resolve => {
		try {

			let $appendedHeader = $('<th data-logonuser="' + logon_user + '" class="smoothFade smoothSlide" style="opacity:0"><div style="position:relative;width:100%;text-align:center"><p class="colDisplayName">' + logon_name + '</p><button class="btn discardChangesBtn"><i class="fas fa-times"></i></button><button class="btn submitChangesBtn"><i class="fas fa-check"></i></button></div></th>').appendTo('#permissionTable > thead > tr');
			
			$appendedHeader.find('.discardChangesBtn').on('click',function(){
				console.log('discard changes clicked');
			});
			
			$appendedHeader.find('.submitChangesBtn').on('click',function(){
				//pass orig_permissions to compare and make sure submitting a change
				//doUpdatePermissions(orig_permissions[logon_user])
				console.log('XML goes here')
			});
				
			$('#permissionTable > tbody').find('tr').each(function(){
				let $trow = $(this);
				let thisFormID = $trow.children('.pTitle').data('formid');

				let thispObj = pObjArr.filter(obj => {
					return obj.FORMID == thisFormID;
				});

				$trow.append('<td data-logonuser="' + logon_user + '" data-logonid="' + logon_id + '" class="userColCell smoothFade" style="opacity:0"><select id="' + logon_user + '_' + thispObj[0].FORMID + '_permissionSelect" class="pSelect" name="' + logon_user + '_' + thispObj[0].FORMID + '_permissionSelect"><option value="-1" ' + ((thispObj[0].LOGON_LEVEL == -1) ? 'selected' : '') + '>No Access</option><option value="1" ' + ((thispObj[0].LOGON_LEVEL == 1) ? 'selected' : '') + '>Read-Only</option><option value="0" ' + ((thispObj[0].LOGON_LEVEL == 0) ? 'selected' : '') + '>Full Access</option></select></td>');
			});



			$('.pSelect').SumoSelect();
			$('.pSelect').on('change',function(){

				$(this).next('p').css({"font-weight":"bold","background-color":"#E8C648"});

				// logon_id, formid, orig val, new val
				//let changeArray = [logon_id,thispObj[0].FORMID,thispObj[0].LOGON_LEVEL,$('#' + logon_user + '_' + thispObj[0].FORMID + '_permissionSelect').val()];
				//changes.push(changeArray);
			});


			
//			setTimeout(function(){
//				$('#permissionTable > thead > tr').find('th:last-child').css('opacity',1);
//				$('#permissionTable > tbody').find('tr > td:last-child').css('opacity',1);
//			},100);
			

			resolve(true);
			
		}
		catch(err) {
			alert(err);
			resolve(false);
		}
		
	});
}

function discardChanges(logon_id){

}
	
	

function removeUserCol(logon_user,user_id) {
	
	$.ajax({
		type: "get",
		url: "permissions_CFC.cfc?method=removeUserCol",
		dataType: "text",
		data: {
			logon_user: logon_user,
			user_id: user_id
		},
		cache: false,
		success: function( data ){
			let json = data.trim();
			let objRes = JSON.parse(json);

			
			if(objRes.status == 'pass'){
				let logon_user = objRes.logon_user;
				
				let $userCol = $('#permissionTable').find('[data-logonuser="' + logon_user + '"]');
				let $labelCol = $('#permissionTable').find('th,td');
				let $tableRows = $('#permissionTable > tbody').find('tr');
				let checkTHead = $('#permissionTable > thead > tr').children();
					
				let removeLabelCol = false;
				if(checkTHead.length <= 2){
					//remove form labels
					removeLabelCol = true;
					$tableRows.css('opacity',0);
				}

				$userCol.css('opacity',0);
				setTimeout(function(){
					$userCol.remove();
					
					if(removeLabelCol){
						$labelCol.remove();
						$tableRows.remove();
						$('#permissionTable > thead > tr').css({'height':'0','opacity':'0'});
						$('#permissionTable > thead').css('border-bottom','2px solid #BEBEBE');
						$('#permissionTable > tbody').css('border-bottom','2px solid #BEBEBE');
						setTimeout(function(){
							$('#appHint').css({'opacity':'1','z-index':'1'});
						},500);
					} else {
						let checkTHead = $('#permissionTable > thead > tr').children();
						let tableW = $('#permissionTable').outerWidth();
						let colWidth = getColWidth(tableW,checkTHead.length);
						adjColWidth(colWidth);
					}
					
				},500);

			} else {
				alert(objRes.reason);
				return false;
			}
		
		}
	});	

}
	
	
	
	
function removeAllUserCol(logon_user_array, user_id_array) {
	
	for(let i = 0; i < logon_user_array.length; i++){
		$.ajax({
			type: "get",
			url: "permissions_CFC.cfc?method=removeUserCol",
			dataType: "text",
			data: {
				logon_user: logon_user_array[i],
				user_id: user_id_array[i]
			},
			cache: false,
			success: function( data ){
				let json = data.trim();
				let objRes = JSON.parse(json);

				if(objRes.status != 'pass'){
					
					alert(objRes.reason);
					return false;
					
				}

			}
		});
	}
	
	
	let $labelCol = $('#permissionTable').find('th,td');
	let $tableRows = $('#permissionTable > tbody').find('tr');
	
	$labelCol.css('opacity',0);
	$tableRows.css('opacity',0);
	setTimeout(function(){
		$labelCol.remove();
		$tableRows.remove();
		$('#permissionTable > thead > tr').css({'height':'0','opacity':'0'});
		$('#permissionTable > thead').css('border-bottom','2px solid #BEBEBE');
		$('#permissionTable > tbody').css('border-bottom','2px solid #BEBEBE');
		setTimeout(function(){
			$('#appHint').css({'opacity':'1','z-index':'1'});
		},500);
	},500);
		

}

	
	
		
	
function getColWidth(tableWidth,numberOfCols) {
	let colWidth = tableWidth / numberOfCols;
	colWidth = colWidth + 'px';
	return colWidth;
}
	
	
function adjColWidth(colWidth) {
	return new Promise(resolve => {
		try {
			$('#permissionTable > thead > tr').children('th').each(function(){
				$(this).css('width',colWidth);
			});

			$('#permissionTable > tbody > tr').children('td').each(function(){
				$(this).css('width',colWidth);
			});

			resolve(true);
		}
		catch(err) {
			alert(err);
			resolve(false);
		}
		
	});
}
	

	
	
	
function removeSelection() {
	
	selectedUsers = [];
	
	let usersToRemove = [];
	let idsToRemove = [];
	
	$('#user-select-list').children('a').each(function(){
		if($(this).hasClass('active')){
			$(this).removeClass('active');
			usersToRemove.push($(this).data('logonuser'));
			idsToRemove.push($(this).data('userid'));
		}
	});
	
	removeAllUserCol(usersToRemove,idsToRemove);
	
	$('#deselectBtn').prop('disabled',true);
	$('#deselectBtn').css("opacity","0.3");
}
	
	
function spliceArray(array,value) {
	let index = array.indexOf(value);

	if (index > -1) {
		array.splice(index, 1);
		return array;
	} else {
		alert('Value does not exist in array.');
		return false;
	}
}
	



	
	
</script>
	
</body>
</html>
