using CatalogService as service from '../../srv/cat-service';
annotate service.CommCriteriaList with @(
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : companycodeText,
        },
        {
            $Type : 'UI.DataField',
            Value : projectText,
        },
        {
            $Type : 'UI.DataField',
            Value : buildingText,
        },
        {
            $Type : 'UI.DataField',
            Value : landText,
        },
        {
            $Type : 'UI.DataField',
            Value : validFrom,
        },
        {
            $Type : 'UI.DataField',
            Value : validTo,
        },
        {
            $Type : 'UI.DataField',
            Value : Version,
        },
    ],
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>GeneralInformation}',
            ID : 'i18nGeneralInformation',
            Target : '@UI.FieldGroup#i18nGeneralInformation',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>LineItems}',
            ID : 'i18nLineItems',
            Target : 'lineitem/@UI.LineItem#i18nLineItems',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Documents',
            ID : 'Documents',
            Target : 'documents/@UI.LineItem#Documents',
        },
    ],
    UI.FieldGroup #i18nGeneralInformation : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : companycode_companycode,
            },
            {
                $Type : 'UI.DataField',
                Value : companycodeText,
            },
            {
                $Type : 'UI.DataField',
                Value : project_project,
            },
            {
                $Type : 'UI.DataField',
                Value : projectText,
            },
            {
                $Type : 'UI.DataField',
                Value : building_building,
            },
            {
                $Type : 'UI.DataField',
                Value : buildingText,
            },
            {
                $Type : 'UI.DataField',
                Value : land_land,
            },
            {
                $Type : 'UI.DataField',
                Value : landText,
            },
            {
                $Type : 'UI.DataField',
                Value : validFrom,
            },
            {
                $Type : 'UI.DataField',
                Value : validTo,
            },
            {
                $Type : 'UI.DataField',
                Value : Version,
            },
        ],
    },
    UI.SelectionFields : [
        companycode_companycode,
        project_project,
        building_building,
        land_land,
        Version,
    ],
    UI.HeaderInfo : {
        Title : {
            $Type : 'UI.DataField',
            Value : 'Commission Criteria',
        },
        TypeName : '',
        TypeNamePlural : '',
    },
);

annotate service.commission with @(
    UI.LineItem #i18nLineItems : [
        {
            $Type : 'UI.DataField',
            Value : contractType_contractType,
        },
        {
            $Type : 'UI.DataField',
            Value : contractTypeText,
        },
        {
            $Type : 'UI.DataField',
            Value : trancheno,
        },
        {
            $Type : 'UI.DataField',
            Value : comrate,
        },
        {
            $Type : 'UI.DataField',
            Value : buyerpayment,
        },
    ]
);

annotate service.documents with @(
    UI.LineItem #Documents : [
        {
            $Type : 'UI.DataField',
            Value : contractType_contractType,
        },
        {
            $Type : 'UI.DataField',
            Value : contractTypeText,
        },
        {
            $Type : 'UI.DataField',
            Value : doctrancheno,
        },
        {
            $Type : 'UI.DataField',
            Value : reason_reason,
        },
        {
            $Type : 'UI.DataField',
            Value : reasonText,
        },
    ]
);

annotate service.CommCriteriaList with {
    companycode @(
        Common.Text : companycodeText,
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'CompanyCodeVH',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : companycode_companycode,
                    ValueListProperty : 'companycode',
                },
                {
                    $Type : 'Common.ValueListParameterOut',
                    ValueListProperty : 'companycodeText',
                    LocalDataProperty : companycodeText,
                },
            ],
        },
        Common.ValueListWithFixedValues : false,
    )
};

annotate service.CommCriteriaList with {
    project @(
        Common.Text : projectText,
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'BusinessEntityVH',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : project_project,
                    ValueListProperty : 'project',
                },
                {
                    $Type : 'Common.ValueListParameterIn',
                    ValueListProperty : 'companycode',
                    LocalDataProperty : companycode_companycode,
                },
                {
                    $Type : 'Common.ValueListParameterOut',
                    ValueListProperty : 'projectText',
                    LocalDataProperty : projectText,
                },
            ],
        },
        Common.ValueListWithFixedValues : false,
    )
};

annotate service.CommCriteriaList with {
    building @(Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'BuildingVH',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : building_building,
                    ValueListProperty : 'building',
                },
                {
                    $Type : 'Common.ValueListParameterIn',
                    ValueListProperty : 'companycode',
                    LocalDataProperty : companycode_companycode,
                },
                {
                    $Type : 'Common.ValueListParameterIn',
                    ValueListProperty : 'project',
                    LocalDataProperty : project_project,
                },
                {
                    $Type : 'Common.ValueListParameterOut',
                    ValueListProperty : 'buildingText',
                    LocalDataProperty : buildingText,
                },
            ],
        },
        Common.ValueListWithFixedValues : false,
        Common.Text : buildingText,
)};

annotate service.CommCriteriaList with {
    land @(
        Common.Text : landText,
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'LandVH',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : land_land,
                    ValueListProperty : 'land',
                },
                {
                    $Type : 'Common.ValueListParameterIn',
                    ValueListProperty : 'companycode',
                    LocalDataProperty : companycode_companycode,
                },
                {
                    $Type : 'Common.ValueListParameterIn',
                    ValueListProperty : 'project',
                    LocalDataProperty : project_project,
                },
                {
                    $Type : 'Common.ValueListParameterOut',
                    ValueListProperty : 'landText',
                    LocalDataProperty : landText,
                },
            ],
        },
        Common.ValueListWithFixedValues : false,
    )
};

annotate service.commission with {
    contractType @(
        Common.Text : contractTypeText,
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'ContractTypeVH',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : contractType_contractType,
                    ValueListProperty : 'contractType',
                },
                {
                    $Type : 'Common.ValueListParameterOut',
                    ValueListProperty : 'contractTypeText',
                    LocalDataProperty : contractTypeText,
                },
            ],
        },
        Common.ValueListWithFixedValues : false,
    )
};

annotate service.documents with {
    contractType @(
        Common.Text : contractTypeText,
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'ContractTypeVH',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : contractType_contractType,
                    ValueListProperty : 'contractType',
                },
                {
                    $Type : 'Common.ValueListParameterOut',
                    ValueListProperty : 'contractTypeText',
                    LocalDataProperty : contractTypeText,
                },
            ],
        },
        Common.ValueListWithFixedValues : false,
    )
};

annotate service.documents with {
    reason @(
        Common.Text : reasonText,
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'reasonVH',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : reason_reason,
                    ValueListProperty : 'reason',
                },
                {
                    $Type : 'Common.ValueListParameterOut',
                    ValueListProperty : 'reasonText',
                    LocalDataProperty : reasonText,
                },
            ],
        },
        Common.ValueListWithFixedValues : false,
    )
};

