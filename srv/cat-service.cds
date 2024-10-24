using my.criteria as my from '../db/schema';

service CatalogService {
    entity CommCriteriaList as projection on my.CommCriteriaList
    actions{
        @(
            cds.odata.bindingparameter.name: '_it',
                Common.SideEffects             : {
                    TargetEntities  : ['_it/lineitem'],
                    TargetProperties: ['_it/Version']
                }
        )
        action go() returns String;
    };
    entity commission as projection on my.commission;
    entity documents as projection on my.documents;
    entity CompanyCodeVH as projection on my.CompanyCodeVH;
    entity BusinessEntityVH as projection on my.BusinessEntityVH;
    entity BuildingVH as projection on my.BuildingVH;
    entity LandVH as projection on my.LandVH;
    entity ContractTypeVH as projection on my.ContractTypeVH;
    entity reasonVH as projection on my.reasonVH;
}
