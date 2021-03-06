<div class="row-fluid" id="${containerId}">
    <div data-bind="foreach:documents">
		<span data-bind="if: (role() == '${filterBy}' || 'all' == '${filterBy}') && role() != '${ignore}' ">
	       	<g:if test="${editable}">
	            <div class="clearfix space-after media" data-bind="template:ko.utils.unwrapObservable(type) === 'image' ? 'imageDocEditTmpl' : 'objDocEditTmpl'"></div>
	        </g:if>
	        <g:else>
	            <div class="clearfix space-after media" data-bind="template:ko.utils.unwrapObservable(type) === 'image' ? 'imageDocTmpl' : 'objDocTmpl'"></div>
	        </g:else>
         </span>
    </div>
</div>

<script id="imageDocTmpl" type="text/html">
    <a class="pull-left" style="width:32px;height:32px;" data-bind="attr:{href:url}" target="_blank">
        <img class="media-object img-rounded span1" data-bind="attr:{src:url}, alt:name" style="width:32px;height:32px;" width="32" height="32" alt="image preview icon">
    </a>
    <div data-bind="template:'imgMediaBody'"></div>
</script>

<script id="objDocTmpl" type="text/html">
    <a class="pull-left" data-bind="attr:{href:url}">
        <img class="media-object" data-bind="attr:{src:filetypeImg(), alt:name}" alt="document icon">
    </a>
    <div data-bind="template:'docMediaBody'"></div>
</script>

<script id="imageDocEditTmpl" type="text/html">
    <div class="btn-group pull-left" style="margin-top:4px;">
        <button class="btn btn-mini" type="button" data-bind="enable:!readOnly,click:$root.deleteDocument"><i class="icon-remove"></i></button>
        <button class="btn btn-mini" type="button" data-bind="enable:!readOnly,click:$root.editDocumentMetadata"><i class="icon-edit"></i></button>
    </div>
    <a class="pull-left" style="width:32px;height:32px;" data-bind="attr:{href:url}" target="_blank">
        <img class="media-object img-rounded span1" data-bind="attr:{src:url, alt:name}" style="width:32px;height:32px;"  alt="image preview icon">
    </a>
    <div data-bind="template:'imgMediaBody'"></div>
</script>

<script id="objDocEditTmpl" type="text/html">
    <div class="btn-group pull-left" style="margin-top:4px;">
        <button class="btn btn-mini" type="button" data-bind="enable:!readOnly,click:$root.deleteDocument"><i class="icon-remove"></i></button>
        <button class="btn btn-mini" type="button" data-bind="enable:!readOnly,click:$root.editDocumentMetadata"><i class="icon-edit"></i></button>
    </div>
    <a class="pull-left" data-bind="attr:{href:url}">
        <img class="media-object" data-bind="attr:{src:filetypeImg(), alt:name}" alt="document icon">
    </a>
    <div data-bind="template:'docMediaBody'"></div>
</script>

<script id="docMediaBody" type="text/html">
    <div class="media-body">
        <a data-bind="attr:{href:url}">
            <h5 class="media-heading" data-bind="text:name"></h5>
        </a>
        <span data-bind="text:attribution"></span>
    </div>
</script>

<script id="imgMediaBody" type="text/html">
    <div class="media-body">
        <a data-bind="attr:{href:url}" target="_blank">
            <h5 class="media-heading" data-bind="text:name"></h5>
        </a>
        <span data-bind="text:attribution"></span>
    </div>
</script>

<r:script>
    var imageLocation = "${imageUrl}",
        useExistingModel = ${useExistingModel};

    $(window).load(function () {

        if (!useExistingModel) {
            var DocModel = function (doc) {
                var self = this;
                this.name = doc.name;
                this.attribution = doc.attribution;
                this.filename = doc.filename;
                this.type = doc.type;
                this.url = doc.url;
                this.filetypeImg = function () {
                    return imageLocation + "/" + iconnameFromFilename(self.filename);
                };
            };
            function DocListViewModel(documents) {
                var self = this;
                this.documents = ko.observableArray($.map(documents, function(doc) { return new DocModel(doc)} ));
            }

            var docListViewModel = new DocListViewModel(${documents ?: []});
            ko.applyBindings(docListViewModel, document.getElementById('${containerId}'));
        }
    });

    function iconnameFromFilename(filename) {
        if (filename === undefined) { return "_blank.png"; }
        var ext = filename.split('.').pop(),
            types = ['aac','ai','aiff','avi','bmp','c','cpp','css','dat','dmg','doc','dotx','dwg','dxf',
            'eps','exe','flv','gif','h','hpp','html','ics','iso','java','jpg','key','mid','mp3','mp4',
            'mpg','odf','ods','odt','otp','ots','ott','pdf','php','png','ppt','psd','py','qt','rar','rb',
            'rtf','sql','tga','tgz','tiff','tif','txt','wav','xls','xlsx'];
        ext = ext.toLowerCase();
        if (ext === 'docx') { ext = 'doc' }
        if ($.inArray(ext, types) >= 0) {
            return ext + '.png';
        } else {
            return "_blank.png";
        }
    }
</r:script>