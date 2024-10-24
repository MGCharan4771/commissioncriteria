sap.ui.define([
    "sap/m/MessageToast"
], function (MessageToast) {
    'use strict';

    return {
        onPressGo: function (oEvent) {
            // MessageToast.show("Custom handler invoked.");
            var object = oEvent.getObject();
            let sActionName = "CatalogService.go";
            let mParameters = {
                contexts: oEvent,
                model: this.getModel(),
                invocationGrouping: true
            };
            this.editFlow.invokeAction(sActionName, mParameters);
        }
    };
});
