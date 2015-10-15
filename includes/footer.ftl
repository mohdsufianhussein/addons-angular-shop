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

        
            </div>
            <!-- /.container-fluid -->



        </div>
        <!-- /#page-wrapper -->


        <footer>
            <div class="row ">
                <div class="col-lg-12 text-center">
                    <p>
                        ${uiLabelMap.CommonCopyright} (c) 2014-${nowTimestamp?string("yyyy")} <a href="http://www.ilscipio.com" target="_blank">ilscipio GmbH</a>. ${uiLabelMap.CommonPoweredBy} <a href="http://www.cato-commerce.com" target="_blank">Cato Commerce.</a> <#include "ofbizhome://runtime/svninfo.ftl" /> <#include "ofbizhome://runtime/gitinfo.ftl" />
                    </p>
                </div>
            </div>
            <!-- /.row -->
        </footer>
        
    </div>
    <!-- /#wrapper -->




    <#-- New in cato; for app scripts that aren't (exclusively) styling but must go at end of page -->
    <#if layoutSettings.javaScriptsFooter?has_content>
        <#assign javaScriptsSet = Static["org.ofbiz.base.util.UtilMisc"].toSet(layoutSettings.javaScriptsFooter)/>
        <#list layoutSettings.javaScriptsFooter as javaScript>
            <#if javaScriptsSet.contains(javaScript)>
                <#assign nothing = javaScriptsSet.remove(javaScript)/>
                <script src="<@ofbizContentUrl>${StringUtil.wrapString(javaScript)}</@ofbizContentUrl>" type="text/javascript"></script>
            </#if>
        </#list>
    </#if>

    <#-- For theme styling-related scripts -->
    <#if layoutSettings.VT_FTR_JAVASCRIPT?has_content>
        <#--layoutSettings.javaScripts is a list of java scripts. -->
        <#-- use a Set to make sure each javascript is declared only once, but iterate the list to maintain the correct order -->
        <#assign javaScriptsSet = Static["org.ofbiz.base.util.UtilMisc"].toSet(layoutSettings.VT_FTR_JAVASCRIPT)/>
        <#list layoutSettings.VT_FTR_JAVASCRIPT as javaScript>
            <#if javaScriptsSet.contains(javaScript)>
                <#assign nothing = javaScriptsSet.remove(javaScript)/>
                <script src="<@ofbizContentUrl>${StringUtil.wrapString(javaScript)}</@ofbizContentUrl>" type="text/javascript"></script>
            </#if>
        </#list>
    </#if>
</body>
</html>
