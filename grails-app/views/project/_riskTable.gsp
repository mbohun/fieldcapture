<label><h4>Project risks & threats <span style="color: red;"><b>*</b></span></h4></label>
<div class="row-fluid space-after">
	<div class="required">
	        <div id="project-risks-threats" class="well well-small">
			  <p>Please enter the details of risks and threats to the project and the mitigation strategies being used to address them. These should be updated at each reporting period:</p>
			  <div align="right"> Overall project risk profile : <span style="color: red;">*</span> 
					<span class="ratingStyling">
						<select data-validation-engine="validate[required]" data-bind="options: ratingOptions, value:risks.overallRisk, optionsCaption: 'Please select', css: overAllRiskHighlight" id="overall-risk"></select>
					 </span>
			  </div>
			  <table style="width:100%;">
			      <thead>
			          <tr>
			            <th>Type of threat / risk <span style="color: red;"><b>*</b></span></th>
			            <th>Description <span style="color: red;"><b>*</b></span></th>
						<th>Likelihood <span style="color: red;"><b>*</b></span></th>			                
						<th>Consequence <span style="color: red;"><b>*</b></span></th>							
						<th>Risk rating</th>
						<th>Current control / <br/>Contingency strategy <span style="color: red;"><b>*</b></span></th>														
						<th>Residual risk <span style="color: red;"><b>*</b></span></th>	
						<th></th>												
			          </tr>
			      </thead>
			      <tbody data-bind="foreach : risks.rows" >
			              <tr>
			                  <td width="18%">
			                  	<select style="width:98%;" data-validation-engine="validate[required]" data-bind="options: $parent.threatOptions, value: threat, optionsCaption: 'Please select'" ></select>
			                  </td>
			                  <td width="20%">
			                  	<textarea style="width:97%;" data-validation-engine="validate[required]" class="input-xlarge" data-bind="value: description"  rows="5"></textarea>
			                  </td>
			                  <td width="10%">
			                  	<select style="width:98%;" data-validation-engine="validate[required]" data-bind="options: $parent.likelihoodOptions, value: likelihood, optionsCaption: 'Please select'" ></select>
			                  </td>
			                  <td width="10%">
								<select style="width:98%;"  data-validation-engine="validate[required]" data-bind="options: $parent.consequenceOptions, value: consequence,  optionsCaption: 'Please select'"></select>
			                  </td>
			                  <td width="8%">
								<b> <span style="width:98%;" data-bind="text:riskRating"></span></b>  
			                  </td>
			                  <td width="20%">
			                   	<textarea style="width:98%;" data-validation-engine="validate[required]"  data-bind="value : currentControl"  rows="5"></textarea>
			                   </td>
			                  <td width="10%">
			                   <!-- Residual risk -->
			                   <select style="width:98%;" data-validation-engine="validate[required]" data-bind="options: $parent.ratingOptions, value: residualRisk, optionsCaption: 'Please select'" ></select>
			                   </td>
			                 <td width="4%">
			                 	<span data-bind="if: $index()"><i class="icon-remove" data-bind="click: $parent.removeRisk"></i></span>
			                 </td>  
			               </tr>
			       </tbody>
							<tfoot>
             				<tr>
             					<td colspan="0" style="text-align:left;">
                     			<button type="button" class="btn btn-small" data-bind="click: addRisks">
                     			<i class="icon-plus"></i> Add a row</button></td>
                     		</tr>
					</tfoot>			       
			       
			   </table>
			   <br/>
			  <button type="button" data-bind="click: saveRisks" class="btn btn-primary">Save risks & threats</button>
        </div>
	    </div>
</div>
