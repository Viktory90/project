import com.olbius.util.PartyUtil;
import org.ofbiz.entity.condition.EntityCondition;

partyId = userLogin.get("partyId");
internalOrgId = PartyUtil.getOrgByManager(partyId, delegator);

deptEmplPosTypeList = delegator.findList("DeptPositionType", EntityCondition.makeCondition("deptId", internalOrgId), null, null, null, false);
context.deptEmplPosTypeList = deptEmplPosTypeList;