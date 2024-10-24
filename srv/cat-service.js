const cds = require('@sap/cds');

class service extends cds.ApplicationService {
    async init() {
        const { CommCriteriaList, commission } = this.entities;
        this.before('CREATE', 'CommCriteriaList', async (req) => {
            const db = await cds.connect.to('db');
            let commInfo = await db.run(SELECT.from(`CatalogService.CommCriteriaList`).where({
                companycode_companycode: req.data.companycode_companycode,
                project_project: req.data.project_project,
                building_building: req.data.building_building,
                land_land: req.data.land_land
            }));
            var Version = '01';
            for (var j = 0; j < commInfo.length; j++) {
                if (commInfo[j].validTo < req.data.validFrom && commInfo[j].Version == '01') {
                    Version = Number(Version) > Number('02') ? Version : '02';
                } else if (commInfo[j].validTo < req.data.validFrom && commInfo[j].Version == '02') {
                    Version = '03';
                } else if (commInfo[j].validTo > req.data.validFrom) {
                    req.error({
                        code: "INPUT_REQUIRED",
                        status: 400,
                        message: `This Validity Period is Already available`
                    })
                    break;
                }
            }

            req.data.Version = Version;

            if ((req.data.building_building == null || req.data.building_building == '') && (req.data.land_land == null || req.data.land_land == '')) {
                req.error({
                    code: "INPUT_REQUIRED",
                    status: 400,
                    message: `Fill in either Building or Land`
                })
            } else if ((req.data.building_building != null && req.data.building_building != '') && (req.data.land_land != null && req.data.land_land != '')) {
                req.error({
                    code: "INPUT_REQUIRED", 
                    status: 400,
                    message: `Fill only either Building or Land`
                })
            }
            if (req.data.validFrom > req.data.validTo) {
                req.error({
                    code: "INPUT_REQUIRED",
                    status: 400,
                    message: `Valid To Should not be before Valid From`
                })
            }
            var lineitem = req.data.lineitem;
            var count = 0;
            for (var i = 0; i < lineitem.length; i++) {
                count = count + Number(req.data.lineitem[i].comrate)
            }
            if (lineitem.length > 0) {
                if (count !== 100) {
                    req.error({
                        code: "INPUT_REQUIRED",
                        status: 400,
                        message: `Total of Commission Rate Should be 100`
                    })
                }
            }
        }),
            this.before('UPDATE', 'CommCriteriaList', async (req) => {
                const db = await cds.connect.to('db');
                let commInfo = await db.run(SELECT.from(`CatalogService.CommCriteriaList`).where({ ID: req.data.ID }));
                let dataInfo = await db.run(SELECT.from(`CatalogService.CommCriteriaList.drafts`).where({ ID: req.params[0].ID }));
                if (commInfo[0].validFrom !== req.data.validFrom) {
                    if (commInfo[0].validFrom >= req.data.validFrom) {
                        req.error({
                            code: "INPUT_REQUIRED",
                            status: 400,
                            message: `Valid From Date should not be Older`
                        })
                    } else {
                        if (dataInfo && dataInfo.length > 0) {
                            if (dataInfo[0].Version == '01') {
                                req.data.Version = '02';
                            } else if (dataInfo[0].Version == '02') {
                                req.data.Version = '03';
                            }
                        }
                    }
                }
                var lineitem = req.data.lineitem;
                var count = 0;
                for (var i = 0; i < lineitem.length; i++) {
                    count = count + Number(req.data.lineitem[i].comrate)
                }
                console.log(count);
                if (lineitem.length > 0) {
                    if (count !== 100) {
                        req.error({
                            code: "INPUT_REQUIRED",
                            status: 400,
                            message: `Total of Commission Rate Should be 100`
                        })
                    }
                }
                console.log(req);
            }),
            this.on('go', 'CommCriteriaList.drafts', async (req) => {
                const db = await cds.connect.to('db');
                let dataInfo = await db.run(SELECT.from(`CatalogService.CommCriteriaList.drafts`).where({ ID: req.params[0].ID }));

                if ((dataInfo[0].building_building == null || dataInfo[0].building_building == '') && (dataInfo[0].land_land == null || dataInfo[0].land_land == '')) {
                    req.error({
                        code: "INPUT_REQUIRED",
                        status: 400,
                        message: `Fill in either Building or Land`
                    })
                } else if ((dataInfo[0].building_building != null && dataInfo[0].building_building != '') && (dataInfo[0].land_land != null && dataInfo[0].land_land != '')) {
                    req.error({
                        code: "INPUT_REQUIRED",
                        status: 400,
                        message: `Fill only either Building or Land`
                    })
                } else {
                    let commInfo = await db.run(SELECT.from(`CatalogService.CommCriteriaList`).where({
                        companycode_companycode: dataInfo[0].companycode_companycode,
                        project_project: dataInfo[0].project_project,
                        building_building: dataInfo[0].building_building,
                        land_land: dataInfo[0].land_land,
                        validFrom: dataInfo[0].validFrom,
                        validTo: dataInfo[0].validTo
                    }))
                    console.log(commInfo)
                    if (commInfo && commInfo.length > 0) {
                        let commissionInfo = await db.run(SELECT.from(`CatalogService.commission`).where({ parent_ID: commInfo[0].ID }));
                        let downpaymetData = await db.run(SELECT.from(commission.drafts).where({ parent_ID: dataInfo[0].ID }));
                        if (downpaymetData && downpaymetData.length > 0)
                            await db.run(DELETE.from(commission.drafts).where({ parent_ID: dataInfo[0].ID }));

                        for (var i = 0; i < commissionInfo.length; i++) {
                            let payload = {
                                "parent_ID": dataInfo[0].ID,
                                "contractType_contractType": commissionInfo[i].contractType_contractType,
                                "trancheno": commissionInfo[i].trancheno,
                                "comrate": commissionInfo[i].comrate,
                                "buyerpayment": commissionInfo[i].buyerpayment,
                                "DraftAdministrativeData_DraftUUID": dataInfo[0].DraftAdministrativeData_DraftUUID
                            }
                            let insRes = await cds.transaction(req).run(INSERT.into(commission.drafts).entries(payload));
                        }
                    }
                    if (commInfo && commInfo.length > 0) {
                        await db.run(async (tx) => {
                            await tx.update('CatalogService.CommCriteriaList.drafts')
                                .set({ Version: commInfo[0].Version })
                                .where({
                                    companycode_companycode: dataInfo[0].companycode_companycode,
                                    project_project: dataInfo[0].project_project,
                                    building_building: dataInfo[0].building_building,
                                    land_land: dataInfo[0].land_land,
                                    validFrom: dataInfo[0].validFrom,
                                    validTo: dataInfo[0].validTo
                                })
                        });
                    }
                }
                console.log(req)
            }),
            this.on('copy', 'commission.drafts', async (req) => {
                console.log(req)
                let ID = req.params[1].ID;
                const db = await cds.connect.to('db');
                let dataInfo = await db.run(SELECT.from(`CatalogService.commission.drafts`).where({ ID: req.params[1].ID }));
                let payload = {
                    "parent_ID": req.params[0].ID,
                    "contractType_REContractType": dataInfo[0].contractType_REContractType,
                    "trancheno": dataInfo[0].trancheno,
                    "comrate": dataInfo[0].comrate,
                    "buyerpayment": dataInfo[0].buyerpayment,
                    "DraftAdministrativeData_DraftUUID": dataInfo[0].DraftAdministrativeData_DraftUUID
                }
                let insRes = await cds.transaction(req).run(INSERT.into(commission.drafts).entries(payload));
            }),
            this.before('CREATE', 'commission.drafts', async (req) => {
                console.log(req)
                const db = await cds.connect.to('db');
                let dataInfo = await db.run(SELECT.from(`CatalogService.commission.drafts`).where({ parent_ID: req.data.parent_ID }));
                if (dataInfo && dataInfo.length >= 0 && dataInfo.length < 10)
                    req.data.trancheno = `${(dataInfo.length === 9 && dataInfo.length < 10) ? dataInfo.length + 1 : `${dataInfo.length + 1}`}`;
                else
                    req.error(`Line Item should not Exceeds More than 10`);
            }),
            this.before('CREATE', 'Documents.drafts', async (req) => {
                console.log(req.data.Documents)
            })
        await super.init()
    }
};
module.exports = service;