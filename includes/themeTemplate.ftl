<#--
* 
* A set of HTML templating macros, part of standard Cato Freemarker API.
* Automatically included at all times.
* Intended to be swappable.
*
* Overrides the default CATO styles located in 
* htmlTemplate.ftl - ofbiz_foundation/framework/common/webcommon/cato/lib/standard/
* 
-->

<#-- Master include: Includes the default macros and allows overrides -->
<#include "component://common/webcommon/includes/cato/lib/standard/htmlTemplate.ftl"> 
<#-- save the existing macro def references so we can delegate to them easily -->
<#assign catoStdTmplLib = copyObject(.namespace)>

<#--
Other patterns:

<#import "component://common/webcommon/includes/cato/lib/standard/htmlTemplate.ftl" as catoStdTmplLib> 

it turns out, using #import statement here as-is is too problematic. within the import calls, local macro definitions will always
shadow the global macro definitions, which means they won't automatically use the overridden macros defined in this parent file, 
so reuse of high-level macros (that call others) becomes confusing.
whether automatic overriding is wanted or not is case-specific, but in general, here yes.
the only way around this would be to modify the namespace using:
<#import ... as catoStdTmplLib>
<#macro row>
</#macro>
<#assign row = row in catoStdTmplLib>
for every major macro (which could be approximated with looped assignments again, but ugly).
note this pattern is acceptable in some other cases because it can be very fine-grained, but here will probably cause only headaches
because in general we wish to override selectively, not include selectively.
-->

<#-- 
*************
* MACRO OVERRIDES
************
 -->

<#-- min only lists the minimal params we need defaults for; @field has too many args, will be faster this way -->
<#assign fieldDefaultArgsCatoBsMin = {"type":"", "class":""}>
<#assign fieldDefaultArgsCatoBs = fieldDefaultArgsCatoStd + fieldDefaultArgsCatoBsMin>
<#macro field args={} inlineArgs...>
    <#-- NOTE: we don't need to use fieldDefaultArgsCatoBs here for the time being, but if this was
        a heavier mod, may want it here instead of fieldDefaultArgsCatoBsMin.
        this is simply an optimization.
        WARN: you have to make sure to include the defaults you need in fieldDefaultArgsCatoBsMin.
    <#local args = mergeArgMaps(args, inlineArgs, fieldDefaultArgsCatoBs)>-->
    <#local args = mergeArgMaps(args, inlineArgs, fieldDefaultArgsCatoBsMin)>
    <#local dummy = localsPutAll(args)>
    
    <#if !type?has_content>
      <#local type = "generic">
    </#if>

    <#-- FIXME? this works to add form-control to inputs, but probably complicates if need to add containers
        (see other FIXMEs) -->
    <#local class = addClassArg(class, "form-control")/>
    
    <#-- FIXME: the following classes don't belong here at all (shouldn't be on <input> elems but only on wrappers), 
        but currently can't add wrappers in markup macro... -->
    <#local fieldEntryTypeClass = "field-entry-type-" + mapCatoFieldTypeToStyleName(type)>
    <#local class = addClassArg(class, "field-entry-widget")/>
    <#local class = addClassArg(class, fieldEntryTypeClass)/>
    
    <#-- NOTE: the inlineArgs always override the args map, so can exploit this to avoid making an extra map -->
    <@catoStdTmplLib.field args=args class=class><#nested /></@catoStdTmplLib.field>
</#macro>

<#-- @field container markup - theme override 
    labelContent is generated by field_markup_labelarea.
    #nested is the actual field widget (<input>, <select>, etc.). -->
<#macro field_markup_container type="" class="" columns="" postfix=false postfixSize=0 postfixContent=true labelArea=true labelType="" labelPosition="" labelAreaContent="" collapse="" collapsePostfix="" norows=false nocells=false container=true extraArgs...>
  <#-- FIXME: the current non-grid arrangement does not properly support parent/child fields which cato macros
      should support (see layoutdemo - "Default form fields (with label area) with parent/child fields") -->
  
  <#local rowClass = "">
  <#--<#local labelAreaClass = "">  
  <#local postfixClass = "">-->
  
  <#if !collapse?has_content>
      <#local collapse = false/>
  </#if>
  <#if !collapsePostfix?has_content>
    <#local collapsePostfix = postfix/>
  </#if>

  <#-- not using grid here...
      NOTE: the spans below don't support extra classes at all right now
  <#local defaultGridStyles = getDefaultFieldGridStyles({"columns":columns, "labelArea":labelArea, "postfix":postfix, "postfixSize":postfixSize })>-->

  <#local fieldEntryTypeClass = "field-entry-type-" + mapCatoFieldTypeToStyleName(type)>
  
  <#local rowClass = addClassArg(rowClass, "form-field-entry " + fieldEntryTypeClass)>
  <@row class=rowClass collapse=collapse!false norows=(norows || !container)>
    <#if labelType == "vertical">
      <#-- FIXME: vertical was mostly copy-pasted quickly so it can be seen visually, needs work -->
      <@cell>
        <div class="form-group input-group">
        <#if labelArea && labelPosition == "top">
          <@row>
            <@cell>
              <#-- FIXME: give label area min width instead of silly &nbsp; -->
              <span class="input-group-addon field-entry-title ${fieldEntryTypeClass}">${labelAreaContent}</span>
            </@cell>
          </@row>
        </#if>
          <@row>
            <@cell>
                <#-- FIXME: currently can't add wrapper without breaking style, so moved these classes to @field override
                <span class="field-entry-widget ${fieldEntryTypeClass}"><#nested></span>
                -->
                <#-- quick hack to add container to things that don't naturally have any (shouldn't
                    be needed, see last FIXME -->
                <#if type == "display">
                  <span class="form-control"><#nested></span>
                <#else>
                  <#nested>
                </#if>
              <#-- FIXME: CSS not working with postfix (form-control goes to width 100% and pushes this to next line) 
                <#if postfix>
                    <span class="field-entry-postfix ${fieldEntryTypeClass}">
                      <#if (postfixContent?is_boolean && postfixContent == true) || !postfixContent?has_content>
                        <span class="postfix"><input type="submit" class="${styles.icon!} ${styles.icon_button!}" value="${styles.icon_button_value!}"/></span>
                      <#elseif !postfixContent?is_boolean>
                        ${postfixContent}
                      </#if>
                    </span>
                </#if>
              -->
              
            </@cell>
          </@row>
        </div>
      </@cell>
    <#else> <#-- elseif labelType == "horizontal" -->
      <@cell class="" nocells=(nocells || !container)>
          <div class="form-group input-group">
              <#if labelArea  && labelType == "horizontal" && labelPosition == "left">
                  <#-- FIXME: give label area min width instead of silly &nbsp; -->
                  <span class="input-group-addon field-entry-title ${fieldEntryTypeClass}"><#if labelAreaContent?has_content>${labelAreaContent}<#else><#list 1..12 as num>&nbsp;</#list></#if></span>
              </#if>
              <#-- FIXME: currently can't add wrapper without breaking style, so moved these classes to @field override
              <span class="field-entry-widget ${fieldEntryTypeClass}"><#nested></span>
              -->
              <#-- quick hack to add container to things that don't naturally have any (shouldn't
                  be needed, see last FIXME -->
              <#if type == "display">
                <span class="form-control"><#nested></span>
              <#else>
                <#nested>
              </#if>
            <#-- FIXME: CSS not working with postfix (form-control goes to width 100% and pushes this to next line) 
              <#if postfix>
                  <span class="field-entry-postfix ${fieldEntryTypeClass}">
                    <#if (postfixContent?is_boolean && postfixContent == true) || !postfixContent?has_content>
                      <span class="postfix"><input type="submit" class="${styles.icon!} ${styles.icon_button!}" value="${styles.icon_button_value!}"/></span>
                    <#elseif !postfixContent?is_boolean>
                      ${postfixContent}
                    </#if>
                  </span>
              </#if>
            -->
          </div>
      </@cell>
    </#if>
  </@row>
</#macro>

<#-- @field label area markup - theme override
    This generates labelContent passed to @field_markup_container. -->
<#macro field_markup_labelarea labelType="" labelPosition="" label="" labelDetail="" fieldType="" fieldId="" collapse="" required=false extraArgs...>
  <#if !collapse?has_content>
      <#local collapse = false/>
  </#if>
  <#if label?has_content>
    <#if !collapse>
        <span class="form-field-label">${label}<#if required> *</#if></span>
    <#else>
        <span class="form-field-label">${label}<#if required> *</#if></span>
    </#if>  
  </#if> 
  <#if labelDetail?has_content>
    ${labelDetail}
  </#if>  
</#macro>

<#-- NOTE: the more "proper" way to modify these is now to override the @menu_markup and @menuitem_markup macros, but
    these are acceptable as well (because of args/inlineArgs pattern) and provides more examples of ways to override. -->
<#assign menuDefaultArgsCatoBsMin = {"htmlWrap":"div"}> <#-- change the default value, but still possible for client to override -->
<#assign menuDefaultArgsCatoBs = menuDefaultArgsCatoStd + menuDefaultArgsCatoBsMin>
<#macro menu args={} inlineArgs...>
    <@catoStdTmplLib.menu args=mergeArgMaps(args, inlineArgs, menuDefaultArgsCatoBsMin)><#nested /></@catoStdTmplLib.menu>
</#macro>

<#assign menuitemDefaultArgsCatoBsMin = {"htmlWrap":false}> <#-- no html wrapper by default -->
<#assign menuitemDefaultArgsCatoBs = menuitemDefaultArgsCatoStd + menuitemDefaultArgsCatoBsMin>
<#macro menuitem args={} inlineArgs...>
    <@catoStdTmplLib.menuitem args=mergeArgMaps(args, inlineArgs, menuitemDefaultArgsCatoBsMin)><#nested /></@catoStdTmplLib.menuitem>
</#macro>

<#macro modal id label href="" icon="">
    <a href="${href!"#"}" data-toggle="modal" data-target="#${id}_modal"><#if icon?has_content><i class="${icon!}"></i> </#if>${label}</a>
    <div id="${id}_modal" class="${styles.modal_wrap!}" role="dialog">
        <div class="modal-dialog">
        <#-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <#nested>
            </div>
            <div class="modal-footer">
            </div>
        </div>
    </div>
</#macro>

<#macro nav type="inline">
    <#switch type>
        <#case "magellan">
            <nav class="navbar navbar-default navbar-static-top"">
              <div class="container">
                <ul class="nav navbar-nav">
                <#nested>
                </ul>
              </div>
            </nav>
        <#break>
        <#case "breadcrumbs">
            <ul class="${styles.nav_breadcrumbs!}">
                <#nested>
            </ul>
        <#break>
        <#default>
            <ul class="${styles.list_inline!} ${styles.nav_subnav!}">
              <#nested>
            </ul>
        <#break>
    </#switch>
</#macro>

<#macro mli arrival="">
    <li><#nested></li>
</#macro>

<#-- since bootstrap doesn't use <li>, this check must be adjusted to something else... -->
<#function isMenuMarkupItemsInline menuContent>
  <#return menuContent?matches(r'(\s*<!--((?!<!--).)*?-->\s*)*\s*<(li|a|span|button|input)(\s|>).*', 'rs')>
</#function>
