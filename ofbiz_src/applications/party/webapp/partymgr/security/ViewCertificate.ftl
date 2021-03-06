<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->

<#assign components = Static["org.ofbiz.base.component.ComponentConfig"].getAllComponents()?if_exists/>
<#if (requestParameters.certString?has_content)>
    <#assign cert = Static["org.ofbiz.base.util.KeyStoreUtil"].pemToCert(requestParameters.certString)/>
</#if>
<div id="findPartyParameters" class="widget-box">
  <div class="widget-header">
      <h3>${uiLabelMap.PageTitleImportCertificate}</h3>
    <br class="clear" />
  </div>
  <div class="widget-body">
    <#if (cert?has_content)>
        <span class="label">${uiLabelMap.PartyCertType}</span>&nbsp;${cert.getType()} : ${cert.getSubjectX500Principal()}
        <span class="label">${uiLabelMap.PartyCertName}</span>&nbsp;${cert.getSubjectX500Principal().getName()}
        <span class="label">${uiLabelMap.PartyCertSerialNumber}</span>&nbsp;${cert.getSerialNumber().toString(16)}
    <#else>
        <h3>${uiLabelMap.PartyCertInvalid}</h3>
    </#if>
  </div>
</div>
<div id="findPartyParameters" class="widget-box">
  <div class="widget-header">
      <h3>${uiLabelMap.PartyCertSaveToKeyStore}</h3>
    <br class="clear" />
  </div>
  <div class="widget-body">
    <table cellspacing="0" class="basic-table">
      <tr class="header-row">
        <td>${uiLabelMap.PartyCertComponent}</td>
        <td>${uiLabelMap.PartyCertKeyStore}</td>
        <td>${uiLabelMap.PartyCertImportIssuer}</td>
        <td>${uiLabelMap.PartyCertKeyAlias}</td>
        <td>&nbsp;</td>
      </tr>
      <#list components as component>
        <#assign keystores = component.getKeystoreInfos()?if_exists/>
          <#list keystores as store>
            <#if (store.isTrustStore())>
              <tr>
                <form method="post" action="<@ofbizUrl>/importIssuerProvision</@ofbizUrl>">
                  <input type="hidden" name="componentName" value="${component.getComponentName()}"/>
                  <input type="hidden" name="keystoreName" value="${store.getName()}"/>
                  <input type="hidden" name="certString" value="${requestParameters.certString}"/>

                  <td>${component.getComponentName()}</td>
                  <td>${store.getName()}</td>
                  <td align="center"><input type="checkbox" name="importIssuer" value="Y"/></td>
                  <td><input type="text" name="alias" size="20"/></td>
                  <td align="right"><button type="submit">
                  <i class="icon-save"></i>
                  ${uiLabelMap.CommonSave}
                  </button>
                  </td>
                </form>
              </tr>
            </#if>
          </#list>
      </#list>
    </table>
  </div>
</div>