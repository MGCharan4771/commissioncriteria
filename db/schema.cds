namespace my.criteria;

@odata.draft.enabled
entity CommCriteriaList {
  key ID              : UUID;
      companycode     : Association to CompanyCodeVH          @mandatory  @Common.Label: 'Company Code';
      companycodeText : String                    @Common.Label: 'Company Code Description';
      project         : Association to BusinessEntityVH       @mandatory  @Common.Label: 'Business Entity';
      projectText     : String                    @Common.Label: 'Business Entity Description';
      building        : Association to BuildingVH @Common.Label: 'Building';
      buildingText    : String                    @Common.Label: 'Building Description';
      land            : Association to LandVH     @Common.Label: 'Land/Property';
      landText        : String                    @Common.Label: 'Land Description';
      validFrom       : Date                      @mandatory  @Common.Label            : 'Valid From';
      validTo         : Date                      @mandatory  @Common.Label            : 'Valid To';
      Version         : String                    @Common.Label: 'Version';
      lineitem        : Composition of many commission
                          on lineitem.parent = $self;
      documents       : Composition of many documents
                          on documents.parent = $self
}

entity commission {
  key ID               : UUID;
  key parent           : Association to CommCriteriaList;
      contractType     : Association to ContractTypeVH        @mandatory  @Common.Label: 'Contract Type';
      contractTypeText : String                   @Common.Label: 'Contract Type Description';
      trancheno        : String(10)               @mandatory  @Common.Label            : 'Tranche Number';
      comrate          : Decimal(5, 2)            @Common.Label: 'Commission Rate';
      buyerpayment     : Decimal(5, 2)            @Common.Label: 'Buyer Payment';
      reason           : Association to reasonVH @Common.Label: 'Document';
}

entity documents {
  key ID               : UUID;
  key parent           : Association to CommCriteriaList;
      contractType     : Association to ContractTypeVH        @mandatory  @Common.Label: 'Contract Type';
      contractTypeText : String                   @Common.Label: 'Contract Type Description';
      doctrancheno     : String(10)               @mandatory  @Common.Label            : 'Tranche Number';
      reason           : Association to reasonVH @Common.Label: 'Document';
      reasonText       : String                   @Common.Label: 'Document Description';
}

entity CompanyCodeVH {
  key companycode     : String;
      companycodeText : String;
}

entity BusinessEntityVH {
  key project     : String;
      companycode : String;
      projectText : String;
}

entity BuildingVH {
  key building     : String;
      companycode  : String;
      project      : String;
      buildingText : String;
}

entity LandVH {
  key land        : String;
      companycode : String;
      project     : String;
      landText    : String;
}

entity ContractTypeVH {
  key contractType     : String;
      contractTypeText : String;
}

entity reasonVH {
  key reason     : String;
      reasonText : String;
}
