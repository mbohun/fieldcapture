<%@ page import="grails.converters.JSON; org.codehaus.groovy.grails.web.json.JSONArray" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/html">
<head>
    <g:if test="${printView}">
        <meta name="layout" content="nrmPrint"/>
        <title>Print | ${activity.type} | Field Capture</title>
    </g:if>
    <g:else>
        <meta name="layout" content="${grailsApplication.config.layout.skin?:'main'}"/>
        <title>Edit | ${activity.type} | Field Capture</title>
    </g:else>

    <script type="text/javascript" src="${grailsApplication.config.google.maps.url}"></script>
    <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jstimezonedetect/1.0.4/jstz.min.js"></script>
    <r:script disposition="head">
    var fcConfig = {
        serverUrl: "${grailsApplication.config.grails.serverURL}",
        activityUpdateUrl: "${createLink(controller: 'activity', action: 'ajaxUpdate')}",
        activityDeleteUrl: "${createLink(controller: 'activity', action: 'ajaxDelete')}",
        projectViewUrl: "${createLink(controller: 'project', action: 'index')}/",
        siteViewUrl: "${createLink(controller: 'site', action: 'index')}/"
        },
        here = document.location.href;
    </r:script>
    <r:require modules="knockout,jqueryValidationEngine,datepicker,jQueryFileUploadUI,mapWithFeatures"/>
</head>
<body>
<div class="container-fluid validationEngineContainer" id="validation-container">
    <div id="koActivityMainBlock">
        <g:if test="${!printView}">
            <ul class="breadcrumb">
                <li><g:link controller="home">Home</g:link> <span class="divider">/</span></li>
                <li><a data-bind="click:goToProject" class="clickable">Project</a> <span class="divider">/</span></li>
                <li class="active">
                    <span data-bind="text:type"></span>
                    <span data-bind="text:startDate.formattedDate"></span><span data-bind="visible:endDate">/</span><span data-bind="text:endDate.formattedDate"></span>
                </li>
            </ul>
        </g:if>

        <div class="row-fluid title-block well well-small input-block-level">
            <div class="span12 title-attribute">
                <h1><span data-bind="click:goToProject" class="clickable">${project?.name?.encodeAsHTML() ?: 'no project defined!!'}</span></h1>
                <g:if test="${hasPhotopointData}">
                    <div class="row-fluid"  style="margin-bottom: 10px;">
                        <span class="alert alert-warning">
                            This activity has photo point data recorded.  The site can only be changed on the full activity data entry page.
                        </span>
                    </div>
                    <h2><span class="span12" data-bind="click:goToSite" class="clickable">Site: ${site.name?.encodeAsHTML()}</span></h2>

                </g:if>
                <g:else>
                    <select data-bind="options:transients.project.sites,optionsText:'name',optionsValue:'siteId',value:siteId,optionsCaption:'Choose a site...'"></select>
                    Leave blank if this activity is not associated with a specific site.
                </g:else>
                <h3 data-bind="css:{modified:dirtyFlag.isDirty},attr:{title:'Has been modified'}">Activity: <span data-bind="text:type"></span><i class="icon-asterisk modified-icon" data-bind="visible:dirtyFlag.isDirty" title="Has been modified"></i></h3>
                <h4><span>${project.associatedProgram?.encodeAsHTML()}</span> <span>${project.associatedSubProgram?.encodeAsHTML()}</span></h4>
            </div>
        </div>

        <div class="row-fluid">
            <div class="span9">
                <!-- Common activity fields -->
                <div class="row-fluid" data-bind="visible:transients.typeWarning()" style="display:none">
                    <div class="alert alert-error">
                        <strong>Warning!</strong> This activity has data recorded.  Changing the type of the activity will cause this data to be lost!
                    </div>
                </div>


                <div class="row-fluid">
                    <div class="span6">
                        <label for="type">Type of activity</label>
                        <select data-bind="value: type, popover:{title:'', content:transients.activityDescription, trigger:'manual', autoShow:true}" id="type" data-validation-engine="validate[required]" class="input-xlarge">
                            <g:each in="${activityTypes}" var="t" status="i">
                                <g:if test="${i == 0 && create}">
                                    <option></option>
                                </g:if>
                                <optgroup label="${t.name}">
                                    <g:each in="${t.list}" var="opt">
                                        <option>${opt.name}</option>
                                    </g:each>
                                </optgroup>
                            </g:each>
                        </select>
                    </div>
                    <div class="span6">
                        <label for="theme">Major theme</label>
                        <select id="theme" data-bind="value:mainTheme, options:transients.themes, optionsCaption:'Choose..'" class="input-xlarge">
                        </select>
                    </div>
                </div>

                <div class="row-fluid">
                    <div class="span12">
                        <fc:textArea data-bind="value: description" id="description" label="Description" class="span12" rows="2" />
                    </div>
                </div>

                <div class="row-fluid">
                    <div class="span6">
                        <label for="plannedStartDate">Planned start date
                        <fc:iconHelp title="Planned start date" printable="${printView}">Date the activity is intended to start.</fc:iconHelp>
                        </label>
                        <div class="input-append">
                            <fc:datePicker targetField="plannedStartDate.date" name="plannedStartDate" data-validation-engine="validate[required]" printable="${printView}"/>
                        </div>
                    </div>
                    <div class="span6">
                        <label for="plannedEndDate">Planned end date
                        <fc:iconHelp title="Planned end date" printable="${printView}">Date the activity is intended to finish.</fc:iconHelp>
                        </label>
                        <div class="input-append">
                            <fc:datePicker targetField="plannedEndDate.date" name="plannedEndDate" data-validation-engine="validate[future[plannedStartDate], required]" printable="${printView}" />
                        </div>
                    </div>
                </div>

            </div>
            <div class="span3">
                    <div id="smallMap" style="width:100%"></div>
            </div>

        </div>

        <g:if env="developkjkment" test="${!printView}">
          <div class="expandable-debug">
              <hr />
              <h3>Debug</h3>
              <div>
                  <h4>KO model</h4>
                  <pre data-bind="text:ko.toJSON($root.modelForSaving(),null,2)"></pre>
                  <h4>Activity</h4>
                  <pre>${activity?.encodeAsHTML()}</pre>
                  <h4>Site</h4>
                  <pre>${site?.encodeAsHTML()}</pre>
                  <h4>Sites</h4>
                  <pre>${(sites as JSON).toString()}</pre>
                  <h4>Project</h4>
                  <pre>${project?.encodeAsHTML()}</pre>
                  <h4>Themes</h4>
                  <pre>${themes.toString()}</pre>
                  <h4>Map features</h4>
                  <pre>${mapFeatures.toString()}</pre>
              </div>
          </div>
        </g:if>
    </div>

    <g:if test="${!printView}">
        <div class="form-actions">
            <button type="button" id="save" class="btn btn-primary">Save changes</button>
            <button type="button" id="cancel" class="btn">Cancel</button>
        </div>
    </g:if>

</div>

<!-- templates -->

<r:script>

    var returnTo = "${returnTo}";

    /* Master controller for page. This handles saving each model as required. */
    var Master = function () {
        var self = this;
        this.subscribers = [];
        // client models register their name and methods to participate in saving
        self.register = function (modelInstanceName, getMethod, isDirtyMethod, resetMethod) {
            self.subscribers.push({
                model: modelInstanceName,
                get: getMethod,
                isDirty: isDirtyMethod,
                reset: resetMethod
            });
        };
        // master isDirty flag for the whole page - can control button enabling
        this.isDirty  = function () {
            var dirty = false;
            $.each(this.subscribers, function(i, obj) {
                dirty = dirty || obj.isDirty();
            });
            return dirty;
        };
        /**
         * Makes an ajax call to save any sections that have been modified. This includes the activity
         * itself and each output.
         *
         * Modified outputs are injected as a list into the activity object. If there is nothing to save
         * in the activity itself, then the root is an object that is empty except for the outputs list.
         *
         * NOTE that the model for each section must register itself to be included in this save.
         *
         * Validates the entire page before saving.
         */
        this.save = function () {
            var activityData, outputs = [];
            if ($('#validation-container').validationEngine('validate')) {
                $.each(this.subscribers, function(i, obj) {
                    if (obj.isDirty()) {
                        if (obj.model === 'activityModel') {
                            activityData = obj.get();
                        } else {
                            outputs.push(obj.get());
                        }
                    }
                });
                if (outputs.length === 0 && activityData === undefined) {
                    alert("Nothing to save.");
                    return;
                }
                if (activityData === undefined) { activityData = {}}
                activityData.outputs = outputs;
                $.ajax({
                    url: "${createLink(action: 'ajaxUpdate', id: activity.activityId)}",
                    type: 'POST',
                    data: JSON.stringify(activityData),
                    contentType: 'application/json',
                    success: function (data) {
                        var errorText = "";
                        if (data.errors) {
                            errorText = "<span class='label label-important'>Important</span><h4>There was an error while trying to save your changes.</h4>";
                            $.each(data.errors, function (i, error) {
                                errorText += "<p>Saving <b>" +
                                 (error.name === 'activity' ? 'the activity context' : error.name) +
                                 "</b> threw the following error:<br><blockquote>" + error.error + "</blockquote></p>";
                            });
                            errorText += "<p>Any other changes should have been saved.</p>";
                            bootbox.alert(errorText);
                        } else {
                            self.reset();
                            self.saved();
                        }
                    },
                    error: function (data) {
                        var status = data.status;
                        alert('An unhandled error occurred: ' + data.status);
                    }
                });
            }

        };
        this.saved = function () {
            document.location.href = returnTo;
        };
        this.reset = function () {
            $.each(this.subscribers, function(i, obj) {
                if (obj.isDirty()) {
                    obj.reset();
                }
            });
        };
    };

    var master = new Master();

    $(function(){

        $('#validation-container').validationEngine('attach', {scroll: false});

        $('.helphover').popover({animation: true, trigger:'hover'});

        $('#save').click(function () {
            master.save();
        });

        $('#cancel').click(function () {
            document.location.href = returnTo;
        });

        $('#reset').click(function () {
            master.reset();
        });

        function ViewModel (act, site, project, activityTypes, themes) {
            var self = this;
            self.activityId = act.activityId;
            self.description = ko.observable(act.description);
            self.notes = ko.observable(act.notes);
            self.startDate = ko.observable(act.startDate).extend({simpleDate: false});
            self.endDate = ko.observable(act.endDate || act.plannedEndDate).extend({simpleDate: false});
            self.plannedStartDate = ko.observable(act.plannedStartDate).extend({simpleDate: false});
            self.plannedEndDate = ko.observable(act.plannedEndDate).extend({simpleDate: false});
            self.eventPurpose = ko.observable(act.eventPurpose);
            self.associatedProgram = ko.observable(act.associatedProgram);
            self.associatedSubProgram = ko.observable(act.associatedSubProgram);
            self.projectStage = ko.observable(act.projectStage || "");
            self.progress = ko.observable(act.progress || 'started');
            self.mainTheme = ko.observable(act.mainTheme);
            self.type = ko.observable(act.type);
            self.siteId = ko.observable(act.siteId);
            self.projectId = act.projectId;
            self.transients = {};
            self.transients.site = ko.observable(site);
            self.transients.project = project;
            self.transients.themes = $.map(themes, function (obj, i) { return obj.name });
            self.transients.typeWarning = ko.computed(function() {
                if (act.outputs === undefined || act.outputs.length == 0) {
                    return false;
                }
                if (!self.type()) {
                    return false;
                }
                return (self.type() != act.type);
            });

            self.transients.activityDescription = ko.computed(function() {
                var result = "";
                if (self.type()) {
                    $.each(activityTypes, function(i, obj) {
                        $.each(obj.list, function(j, type) {
                            if (type.name === self.type()) {
                                result = type.description;
                                console.log(result);
                                return false;
                            }
                        });
                        if (result) {
                            return false;
                        }
                    });
                }
                return result;
            });

            self.siteId = ko.observable(act.siteId);

            self.siteId.subscribe(function(siteId) {

                var matchingSite = $.grep(self.transients.project.sites, function(site) { return siteId == site.siteId})[0];

                if (matchingSite) {

                    alaMap.clearFeatures();
                    alaMap.replaceAllFeatures([matchingSite.extent.geometry]);
                }
                else {
                    alaMap.clearFeatures();
                }
                self.transients.site(matchingSite);
            });

            self.goToProject = function () {
                if (self.projectId) {
                    document.location.href = fcConfig.projectViewUrl + self.projectId;
                }
            };
            self.goToSite = function () {
                if (self.siteId()) {
                    document.location.href = fcConfig.siteViewUrl + self.siteId();
                }
            };
            self.modelForSaving = function () {
                // get model as a plain javascript object
                var jsData = ko.toJS(self);

                delete jsData.transients;
                // If we leave the site or theme undefined, it will be ignored during JSON serialisation and hence
                // will not overwrite the current value on the server.
                var possiblyUndefinedProperties = ['siteId', 'mainTheme'];

                $.each(possiblyUndefinedProperties, function(i, propertyName) {
                    if (jsData[propertyName] === undefined) {
                        jsData[propertyName] = '';
                    }
                });

                return jsData;
            };
            self.modelAsJSON = function () {
                return JSON.stringify(self.modelForSaving());
            };

            self.save = function (callback, key) {
            };
            self.dirtyFlag = ko.dirtyFlag(self, false);
        };


        var viewModel = new ViewModel(
            ${(activity as JSON).toString()},
            ${site ?: 'null'},
            ${project ?: 'null'},
            ${(activityTypes as JSON).toString()},
            ${themes});


        var mapFeatures = $.parseJSON('${mapFeatures?.encodeAsJavaScript()}');
        if (!mapFeatures) {
            mapFeatures = {zoomToBounds: true, zoomLimit: 15, highlightOnHover: true, features: []};
        }

        init_map_with_features({
                mapContainer: "smallMap",
                zoomToBounds:true,
                zoomLimit:16,
                featureService: "${createLink(controller: 'proxy', action:'feature')}",
                wmsServer: "${grailsApplication.config.spatial.geoserverUrl}"
            },
            mapFeatures
        );

        ko.applyBindings(viewModel,document.getElementById('koActivityMainBlock'));

        master.register('activityModel', viewModel.modelForSaving, viewModel.dirtyFlag.isDirty, viewModel.dirtyFlag.reset);

    });
</r:script>
</body>
</html>