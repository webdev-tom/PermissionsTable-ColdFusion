<cfcomponent>

	<!--- 
		***** GET USERS ***** 

		Returns a JSON string of users from ERP based on input criteria.
		
		ARGS:
			activationStatus
				Type: String
				Possible values: "ALL", "1", "0"
				Purpose: Controls whether the function should filter users based on activation status
	--->
	<cffunction name="getUsers" access="remote" output="yes">
		<cfargument name="activationStatus" type="string" default="ALL" required="yes">
			
		<cfset status = 'pass'>
		<cfset reason = ''>
		<cfset JSONresult = '""'>
	
		<cftry>


		<cfquery name="users" datasource="cfweb">
			SELECT * FROM PERMISSIONS_Logon
			<cfif arguments.activationStatus neq 'ALL'>
				WHERE ACTIVE = <cfqueryparam value="#arguments.activationStatus#" cfsqltype="cf_sql_bit">
			</cfif>
		</cfquery>

		
		<cfif users.recordCount>
			<cfset JSONresult = '['>
			<cfloop query="users">
				<cfset newLogonName = ReReplaceNoCase(users.LOGON_NAME,chr(34),' ','all')>
				<cfif users.currentRow eq users.recordCount>
					<cfset JSONresult &= '{"LOGON_ID":"#users.LOGON_ID#","LOGON_USER":"#users.LOGON_USER#","LOGON_NAME":"#newLogonName#"}]'>
				<cfelse>
					<cfset JSONresult &= '{"LOGON_ID":"#users.LOGON_ID#","LOGON_USER":"#users.LOGON_USER#","LOGON_NAME":"#newLogonName#"},'>
				</cfif>
			</cfloop>
		<cfelse>
			<cfset JSONresult = 0>
			<cfset status = 'fail'>
			<cfset reason = 'Error: No users found...'>
		</cfif>
							
		<cfcatch>
			<cfset status = 'fail'>
			<cfset reason = 'Error: #cfcatch.detail# .. #cfcatch.message#. The web admin has been notified.'>
			
			<cfmail to="dev@tomfafard.com" from="dev@tomfafard.com" subject="permissions_CFC: getUsers failed" type="HTML">
				<cfdump var="#cfcatch#">
			</cfmail>
		</cfcatch>	
		</cftry>
				
				
		<cfset result = '{"status":"#status#","reason":"#reason#","json_result":#JSONresult#}'>
			
	
		<cfoutput>#result#</cfoutput>
	</cffunction>
				
				
	
				
				
	<!--- 
		***** GET SECURITY FORMS ***** 

		Returns a JSON string of FORMS (security categories) from Imaginera.
		
		ARGS:
			None

	--->
	<cffunction name="getForms" access="remote" output="yes">
			
		<cfset status = 'pass'>
		<cfset reason = ''>
	
		<cftry>

		<cfquery name="forms" datasource="cfweb">
			SELECT * FROM PERMISSIONS_Forms
		</cfquery>

		
		<cfif forms.recordCount>
			<cfset JSONresult = '['>
			<cfloop query="forms">
				<cfset newFormTitle = ReReplaceNoCase(forms.FORMTITLE,chr(34),' ','all')>
				<cfif forms.currentRow eq forms.recordCount>
					<cfset JSONresult &= '{"FORMID":"#forms.FORMID#","FORM":"#forms.FORM#","FORMTITLE":"#newFormTitle#"}]'>
				<cfelse>
					<cfset JSONresult &= '{"FORMID":"#forms.FORMID#","FORM":"#forms.FORM#","FORMTITLE":"#newFormTitle#"},'>
				</cfif>
			</cfloop>
		<cfelse>
			<cfset JSONresult = 0>
			<cfset status = 'fail'>
			<cfset reason = 'Error: No forms found...'>
		</cfif>
							
		<cfcatch>
			<cfset status = 'fail'>
			<cfset reason = 'Error: #cfcatch.detail# .. #cfcatch.message#. The web admin has been notified.'>
			
			<cfmail to="dev@tomfafard.com" from="dev@tomfafard.com" subject="permissions_CFC: getForms failed" type="HTML">
				<cfdump var="#cfcatch#">
			</cfmail>
		</cfcatch>	
		</cftry>
				
				
		<cfset result = '{"status":"#status#","reason":"#reason#","json_result":#JSONresult#}'>

	
		<cfoutput>#result#</cfoutput>
	</cffunction>


	<!--- 
		***** GET USER COLUMN ***** 

		Returns a JSON string of a user's permissions based on a LOGON_USER value.
		
		ARGS:
			LOGON_USER
				Type: String
				Possible values: Valid LOGON_USER value from Permissions_Logon table
				Purpose: Simply passed through the function for JavaScript to reference later on.
            USER_ID
				Type: Int
				Possible values: Valid LOGON_ID value from Permissions_Logon table
				Purpose: Allows us to pull permissions for a specific user.
			WEB_USER
				Type: String
				Possible values: The current user making this request ( based on session )
				Purpose: Used as a reference point to track which web users are accessing which permissions.

	--->
	<cffunction name="getUserCol" access="remote" output="yes">
		<cfargument name="LOGON_USER" type="string" default="x" required="yes">
		<cfargument name="USER_ID" type="numeric" default="-1" required="yes">
		<cfargument name="WEB_USER" type="string" default="Guest">
			
		<cfset status = 'pass'>
		<cfset reason = ''>
		<cfset JSONresult = '""'>
	
		<cftry>

		<cfif USER_ID neq -1>

			<cfquery name="checkEditing" datasource="cfweb">
				SELECT *
				FROM PERMISSIONS_Editing
				WHERE LOGON_ID = <cfqueryparam value="#arguments.USER_ID#" cfsqltype="cf_sql_integer" maxlength="3">
			</cfquery>

			<cfif checkEditing.recordcount eq 0>

				<cfquery name="userPermissions" datasource="cfweb">
					SELECT *
					FROM PERMISSIONS_Levels
					WHERE LOGON_ID = <cfqueryparam value="#arguments.USER_ID#" cfsqltype="cf_sql_integer" maxlength="3">
				</cfquery>

				<cfif userPermissions.recordCount>
					<cfset JSONresult = '{"LOGON_USER":"#arguments.LOGON_USER#","PERMISSIONS":['>
					<cfloop query="userPermissions">
						<cfif userPermissions.LOGON_LEVEL eq ''>
							<!--- Make sure to set NULLs to 'No Access' --->
							<cfset userPermissions.LOGON_LEVEL = -1>
						</cfif>
						<cfif userPermissions.currentRow eq userPermissions.recordCount>
							<cfset JSONresult &= '{"FORMID":"#userPermissions.FORMID#","LOGON_LEVEL":"#userPermissions.LOGON_LEVEL#"}]}'>
						<cfelse>
							<cfset JSONresult &= '{"FORMID":"#userPermissions.FORMID#","LOGON_LEVEL":"#userPermissions.LOGON_LEVEL#"},'>
						</cfif>
					</cfloop>


					<cfquery name="insertEditing" datasource="cfweb">
						INSERT INTO Permissions_Editing (LOGON_ID,WEB_USER)
						VALUES (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.USER_ID#" maxlength="3">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.WEB_USER#" maxlength="50">)
					</cfquery>

				<cfelse>
					<cfset JSONresult = 0>
					<cfset status = 'fail'>
					<cfset reason = 'User data was not found.'>
				</cfif>

			<cfelse>
				<cfset status = 'fail'>
				<cfset reason = '#arguments.LOGON_USER# is currently being edited by #checkEditing.WEB_USER#.\nYou may make changes once they are finished.'>
			</cfif>

		<cfelse>
			<cfset status = 'fail'>
			<cfset reason = 'You must pass a valid user id..'>
		</cfif>
							
		<cfcatch>
			<cfset status = 'fail'>
			<cfset reason = 'Error: #cfcatch.detail# .. #cfcatch.message#. The web admin has been notified.'>
			
			<cfmail to="dev@tomfafard.com" from="dev@tomfafard.com" subject="permissions_CFC: getUserCol failed" type="HTML">
				<cfdump var="#cfcatch#">
			</cfmail>
		</cfcatch>	
		</cftry>
				
				
		<cfset result = '{"status":"#status#","reason":"#reason#","json_result":#JSONresult#}'>
			
	
		<cfoutput>#result#</cfoutput>
	</cffunction>
				
				
	<!--- 
		***** REMOVE USER COLUMN ***** 

		Removes the passed $web_user from the Permissions_Editing table.
        Other users will now have the opportunity to make changes to this LOGON_ID.

		ARGS:
			LOGON_USER
				Type: String
				Possible values: Valid LOGON_USER value from Permissions_Logon table
				Purpose: Simply passed through the function for JavaScript to reference later on.
            USER_ID
				Type: Int
				Possible values: Valid LOGON_ID value from Permissions_Logon table
				Purpose: The user we'd like to remove from the Permissions_Editing table.
			WEB_USER
				Type: String
				Possible values: The current user making this request ( based on session )
				Purpose: The web user we'd like to remove from the Permissions_Editing table.

	--->
	<cffunction name="removeUserCol" access="remote" output="yes">
		<cfargument name="LOGON_USER" type="string" default="x" required="yes">
		<cfargument name="USER_ID" type="numeric" default="-1" required="yes">
		<cfargument name="WEB_USER" type="string" default="Guest">
			
		<cfset status = 'pass'>
		<cfset reason = ''>
		<cfset thisLogonUser = arguments.LOGON_USER>
	
		<cftry>
			
		<cfif USER_ID neq -1>

			<cfquery name="updateEditing" datasource="cfweb">
				DELETE FROM PERMISSIONS_Editing
				WHERE LOGON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.USER_ID#" maxlength="3">
				AND WEB_USER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.WEB_USER#" maxlength="50">
			</cfquery>

			
		<cfelse>
			<cfset status = 'fail'>
			<cfset reason = 'You must pass a valid user id..'>
		</cfif>
							
		<cfcatch>
			<cfset status = 'fail'>
			<cfset reason = 'Error: #cfcatch.detail# .. #cfcatch.message#. The web admin has been notified.'>
			
			<cfmail to="dev@tomfafard.com" from="dev@tomfafard.com" subject="permissions_CFC: getUserCol failed" type="HTML">
				<cfdump var="#cfcatch#">
			</cfmail>
		</cfcatch>	
		</cftry>
				
				
		<cfset result = '{"status":"#status#","reason":"#reason#","logon_user":"#thisLogonUser#"}'>
			
	
		<cfoutput>#result#</cfoutput>
	</cffunction>














</cfcomponent>
