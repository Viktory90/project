<@jqGridMinimumLib/>

<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxtree.js"></script>


<div id="window" style="display: none;">
    <div id="windowHeader">
        <span>
            Configuration
        </span>
    </div>
    <div style="overflow: hidden;" id="windowContent">
        <div class="row-fluid">
            <div style="margin-left: 20px">
                <div style="float:left;width: 400px;" <#--class="span7"-->>
                    <div style='margin-top: 5px;float: left;width: 90px;'>
                        Party
                    </div>
                    <div id='jqxOlbiusTree' style='visibility: hidden; margin-left: 20px;'></div>
                </div>
                <div style="float: right;width: 290px;margin-right: -20px;" id="_choose">
                </div>
            </div>
            <div class="span12" style="text-align: center;margin: auto;margin-top: 20px;">
                <button id="btn_ok" type="button" class="btn btn-primary btn-mini"
                        style="margin:0px auto;">
                    <i class="icon-ok"></i>OK
                </button>
            </div>
        </div>

    </div>
</div>

<div style='margin-top: 3px;'>
    <button id="btn_olap" type="button" class="btn btn-primary btn-mini" style="float:right;">
        <i class="fa-cogs"></i>
    </button>
</div>
<div class="clearfix"></div>

<script type="text/javascript">

    var popup = (function () {
                var append = false;
                $.jqx.theme = 'olbius';
                var theme = $.jqx.theme;

                function _addEventListeners() {
                    $('#btn_olap').click(function () {
                        if (!append) {
                            $("#_choose").hide();
                            $('#window').jqxWindow('resizable', true);
                            $('#window').jqxWindow('resize', 450, 400);
                            $('#window').jqxWindow('resizable', false);
                            append = true;
                        }
                        $('#window').jqxWindow('open');
                    });
                };
                function _createWindow() {
                    $('#window').jqxWindow({
                        showCollapseButton: false,
                        maxWidth: 720,
                        isModal: true,
                        minWidth: 450,
                        height: 400,
                        width: 720,
                        theme: theme,
                        resizable: false, draggable: true,
                        initContent: function () {
                            $('#window').jqxWindow('focus');
                            $('#window').jqxWindow('close');
                        }
                    });
                };
                function _createTree() {
                    var source = [];

                    jQuery.ajax({
                        url: 'getAllPartyParent',
                        async: false,
                        type: 'POST',
                        success: function (data) {

                            for (var i in data.parent) {
                                source.push({
                                    label: data.parent[i],
                                    id: data.parent[i],
                                    value: [data.parent[i]],
                                    "items": [{"label": "Loading..."}]
                                });
                            }

                        }
                    });

                    $('#jqxOlbiusTree').jqxTree({source: source, width: '300px', height: '300px'});

                    $('#jqxOlbiusTree').css('visibility', 'visible');

                    $('#jqxOlbiusTree').on('expand', function (event) {
                        var _item = $('#jqxOlbiusTree').jqxTree('getItem', event.args.element);
                        var label = _item.label;
                        var value = _item.value;
                        var $element = $(event.args.element);
                        var loader = false;
                        var loaderItem = null;
                        var children = $element.find('ul:first').children();
                        $.each(children, function () {
                            var item = $('#jqxOlbiusTree').jqxTree('getItem', this);
                            if (item && item.label == 'Loading...') {
                                loaderItem = item;
                                loader = true;
                                return false
                            }
                        });
                        if (loader) {
                            jQuery.ajax({
                                url: 'getChildParty',
                                async: true,
                                type: 'POST',
                                data: {"parent": label},
                                success: function (data) {
                                    var items = [];
                                    for (var i in data.child) {
                                        var _value = [];
                                        _value.push(data.child[i]);
                                        _value = _value.concat(value);
                                        items.push({
                                            label: data.child[i],
                                            id: data.child[i],
                                            value: _value,
                                            "items": [{"label": "Loading..."}]
                                        });
                                    }
                                    $('#jqxOlbiusTree').jqxTree('addTo', items, $element[0]);
                                    $('#jqxOlbiusTree').jqxTree('removeItem', loaderItem.element);
                                }
                            });
                        }
                    });
                }

                return {
                    config: {
                        dragArea: null
                    },
                    init: function () {
                        _addEventListeners();
                        _createWindow();
                        _createTree();
                    },
                    _addDropDownList: function (id, label, data, index) {
                        append = true;
                        var text = "<div style='float:left;'>";
                        text += "<div style='margin-top: 5px;float: left;width: 90px;'>";
                        text += label;
                        text += "</div>";
                        text += "<div id='" + id + "' style='float: right'></div>"
                        text += "</div>";

                        $("#_choose").append(text);
                        $("#" + id).jqxDropDownList({
                            source: data,
                            selectedIndex: index,
                            width: '140',
                            height: '25'
                        });
                    },
                    _addDateTimeInput: function (id, label, format, value) {
                        append = true;
                        var text = "<div style='float:left;'>";
                        text += "<div style='margin-top: 5px;float: left;width: 90px;'>";
                        text += label;
                        text += "</div>";
                        text += "<div id='" + id + "' style='display:inline-block; vertical-align:top;margin-left:0px !important;'></div>"
                        text += "</div>";

                        $("#_choose").append(text);

                        $("#" + id).jqxDateTimeInput({width: '140', height: '25', formatString: format, theme: theme});
                        if (value) {
                            $("#" + id).val(value);
                        }
                    },
                    _getParty: function () {
                        var item = $('#jqxOlbiusTree').jqxTree('getSelectedItem');
                        if (item) {
                            return item.value;
                        } else {
                            return [];
                        }
                    },
                    _addOK: function (click) {
                        $('#btn_ok').click(click);
                    },
                    _loadPopup: function () {
                        $("#test").jqxDropDownList({
                            source: ["RECEIVE", "EXPORT", "INVENTORY", "BOOK", "AVAILABLE"],
                            selectedIndex: 1,
                            width: '140',
                            height: '25'
                        });
                    },
                    _close: function () {
                        $('#window').jqxWindow('close');
                    }
                };
            }
            ()
            )
            ;

    $(function () {

        popup.init();
//        popup._loadPopup();
//        popup._addDropDownList("test", "Choose", ["RECEIVE", "EXPORT", "INVENTORY", "BOOK", "AVAILABLE"], 0);
//        popup._addDateTimeInput("testdate", "date", "yyyy-MM-dd", null);
//        console.log(popup._getParty());
        popup._addOK(function () {
            $('#window').jqxWindow('resize', 500, 400);
        });
    });
</script>