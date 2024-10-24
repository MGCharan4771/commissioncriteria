sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'criteriaapp/test/integration/FirstJourney',
		'criteriaapp/test/integration/pages/CommCriteriaListList',
		'criteriaapp/test/integration/pages/CommCriteriaListObjectPage'
    ],
    function(JourneyRunner, opaJourney, CommCriteriaListList, CommCriteriaListObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('criteriaapp') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheCommCriteriaListList: CommCriteriaListList,
					onTheCommCriteriaListObjectPage: CommCriteriaListObjectPage
                }
            },
            opaJourney.run
        );
    }
);