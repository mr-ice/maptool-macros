- [Log4MT](#log4mt)
  * [Installation](#installation)
      - [Installing Wrappers](#installing-wrappers)
      - [Configure Wrappers](#configure-wrappers)
    + [Logging Configuration](#logging-configuration)
      - [Key](#key)
      - [Log Level](#log-level)
      - [l4m/log commands](#l4m-log-commands)
      - [Categories](#categories)
  * [Active and Passive usage](#active-and-passive-usage)
      - [Active](#active)
      - [Passive](#passive)
  * [Profiling](#profiling)
  * [Stack Traces](#stack-traces)
  * [L4m.Break](#l4mbreak)
  * [Examples](#examples)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>


# Log4MT
Log4MT is a drop-in logging framework designed to provide granular control of macro logging. Log events can be filtered by either leveraging the corresponding 'l4m' functions or from the "passive" approach, allowing macros to continue using 'log' functions without creating any new dependencies. In addition to configurable logging control, Log4MT also provides profiling capability and call stack tracking.

## Installation
Log4MT is a token library with the same requirements as any other token library. No additional action is required in order to take advantage of the logging framework. However, in order to take advantage of passive log control, profiling, and call stack tracking, Wrappers must be installed. Wrappers can only be applied to macros that are called via a User Defined Function (UDF). Any library macros that are executed using the "classic" notation "[macro (MacrName@TokenLib): ]" can not be wrapped.

#### Installing Wrappers
1. Execute the Log4MT macro "Install Wrappers".
1. You'll be prompted to select the token library you want to install wrappers for. The follow-up confirmation is in regards to the forthcoming proxy library that will be created. If a token with the same name ("_Library name_-Proxy") already exists, its macros will be overwritten.
1. After confirming, the wrapper proxy token will be generated and wrappers will be installed. The operation will then launch the "Configure Wrappers" macro.

#### Configure Wrappers
This macro configures the wrapper functions. Wrappers are user defined functions that overwrite the existing user defined function of the same name. In order for the wrappers to function correctly, they must be configured in the same manner their corresponding UDFs were configured. For example, if a user defined function 'dnd5e_Constants' was configured to not create a new scope and to ignore output, the wrapper of the same name must be configured the same way. Once the wrappers are configured, you can return to this macro at a later time to update the configuration.

"Immediately Overwrite Original Functions": This option will redefine the configured UDFs upon submission of the form. Once the wrapper functions are overwriting the original functions, the wrappers are active. In order to disable the wrappers, refresh the campaign (start or stop the server, or reload the campaign). After refreshing the campaign, the original UDFs will be in place. Once configured, wrappers may also be enabled by executing the macro "Overwrite UDFs" on the proxy library.

**Caution:** It's very easy to lose track of whether or not wrappers are enabled. In the event "Install Wrappers" is invoked while wrappers are already enabled, the configuration form will display unexpected values, like 'redefined_15_dnd5e_Constants'. In this case, the wrapper installation is attempting to wrap the existing wrappers. This is easily remedied: Refresh the server and re-run "Install Wrappers".

### Logging Configuration
Logging is configured via the "Configure Logging" macro on Lib:Log4MT. Launching it will bring up a dialog with a free-form text field (it may need to be resized manually to better view it):

![](https://github.com/mr-ice/maptool-macros/blob/128d10dce6bd82a062382a31af6754d74606baba/Wiki/l4m_cfgLogging.png?raw=true)

The configuration is a JSON object where the Key is the logger to configure and the value is the log level to define.
#### Key
The logger key is in the format of 'logger.[identifier].[suffix]'.
* Identifier - This is a value corresponding to a Category, Package, or Macro Name. Each configuration corresponds to on identifier. 
> * Category - This is a user defined value. It can be anything keeping in mind "root" is a reserved value. Levels configured for root are globally applied to all log events which either specify an undefined category, or no category.
> * Package -  For complex token libraries with several dozen macros, one may find they rely on a naming scheme that collects macros together, as a package. Macro names are split based on a delimiter character (. and _) to derive these package names. For example, consider the macro "dnd5e_DiceRoller_roll". Two packages are detected in this format: 'dnd5e' & 'DiceRoller'. Either of these packages may have log configurations defined for them.
> * Macro Name - And of course, the macro name itself is an identifier
* Suffix - suffixes designate what logger is being defined. For any category, there are three loggers:
> * level - This is used to define standard macro logging. The value specified allows logging at that level and above to filter through to the log from their corresponding log/l4m commands. Eg. the logger 'logger.dnd5e_DiceRoller_roll.level:DEBUG' will allow log events from log.debug & l4m.debug and up while filter out log.trace. Wrappers are NOT required for this function.
> * entryexit - Is used to define Entry/Exit logging for the specified identifier. The value need only be 'ENABLED' or 'DISABLED'. When enabled, macros that match the identifier will have entry and exit log events generated. Entry and exit log events are generated using the category '[Library Token].[Macro Name]'. Wrappers ARE REQUIRED for this function.
> * break - As with entryexit, break requires only ENABLED or DISABLED. The break loggers correspond to the 'l4m.break' command. In order for the l4m.break command to interrupt the macro flow, the passed category must be enabled via this logger configuration. Wrappers are NOT required for this function.

#### Log Level
Five values are supported (case doesn't matter): ERROR, WARN, INFO, DEBUG, TRACE. For "logger" keys, the it defines the level of log events that will be displayed in the log file. Priority starts at ERROR and increases all the way to TRACE. Log events that are generated at the same or higher priority will be sent to the log file. For instance, if a log even is generated with "log.info", it will only be sent to the log if the associated category is configured with INFO, DEBUG, or TRACE.

#### l4m/log commands
Lib:Log4MT overwrites 'log.x' functions as user defined functions that map to their corresponding 'l4m.x' function. Therefore, when Lib:Log4MT is installed, all 'log' commands are actually calling 'l4m' commands. Therefore, the syntax for 'l4m' commands may also apply to 'log' commands. 'log' will be used for the remainder of this documentation, keeping in mind 'log' and 'l4m' are interchangeable.

All 'log.x' functions have two method signatures:
> * log.x (category, message) - This format has its pros and cons. In this format, the category is explicitly passed apart from the message. However, this signature is specific to Lib:Log4MT and forces Lib:Log4MT to be a dependent library to your macro.
> * log.x (message) - This format is the core signature for MapTools 'log' functions. Using this loosely couples Lib:Log4MT to your macro, allowing the macro to run completely independently of Lib:Log4MT. Further, Lib:Log4MT can always be re-introduced to the campaign at a later point and the log events will automatically begin leveraging the logging configuration framework. When using this signature, the category can still be defined as part of the log message: ```log.debug ("Lib:DnD5e.dnd5e_DiceRoller_roll ## This is the actual log message")``` The secondary delimiter '##' will identify the category from within the log event message.

#### Categories
When executing an active log event using one of the 'log' commands, an identifier is expected. In the previous section, identifiers were categorized as Categories, Packages, and Macro Names. These are effectively overloaded terms as all three are internalized as Categories. It's simply their position in the category chain that differentiates them. The category chain may be composed of zero or more categories, delimited by the period. All category chains are prepended with the root category to ensure they have some corresponding configuration. A typical category chain is [Library Token].[Macro Name]. For example, the macro 'dnd5e_DiceRoller_roll' on the library token 'Lib:DnD5e', as a best practice, should use the category chain 'Lib:DnD5e.dnd5e_DiceRoller_roll'. This category chain will be broken up from left to right, going least significant to most significant. The category that is most significant, or on the end of the chain, will be further broken up into packages based on the underscore delimiter. These packages are inserted into the category chain, making packages more significant than all categories, except the last one. Which, by way of best practice, is the macro name. Returning to our example 'Lib:DnD5e.dnd5e_DiceRoller_roll', the following category chain will be ultimately constructed:
```[root, Lib:DnD5e, dnd5e, DiceRoller, dnd5e_DiceRoller_roll]``` The logger will evaluate the configured loggers for each category in this chain, starting from the least significant 'root' and ending with most significant 'dnd5e_DiceRoller_roll'. The logger defined for the most significant category will be the effective logger for this category chain.

## Active and Passive usage
#### Active
Active usage is when an implementer uses the five logging functions in their macros and explicitly defines the categories for those log events. These functions will invoke log events at the appropriate level for the configured category. When the log event is generated at run time, the logger configuration will be consulted to determine if that event should be sent to the logfile. In addition to these functions to invoke log events, corresponding "ifEnabled" functions are provided that allow the implementer to scope blocks of code around what the effective logging is for the given category.

**Usage:** 
```log.debug([Category,] LogEvent)```
If a Category is not passed, the root category will apply.
```l4m.ifDebugIsEnabled (Category)```
Will return true (1) or false (0) if the passed category has the expected log level enabled.

**Benefits:**
Your macro is able to take advantage of a highly configurable logging framework, natively. There is no need to leverage wrappers to wrap the macros making its usage intuitive and unencumbered.

**Drawback:**
As of MT 1.6*, the performance difference between the native ```log.debug()``` and L4M's ```log.debug()``` is tenfold. On average, the native 'log.' functions execute within 10-20 milliseconds whereas the corresponding 'l4m' functions average 100-200 milliseconds, per call. This can add up and potentially impact the overall performance of the macro. Further, as noted previously, using the two parameter call signature of these methods creates a dependency to lib:Log4MT library. Any consumer of your libraries would also need to ensure Log4MT is also available.

#### Passive
Passive usage of the framework is when an implementer designs their macro as if Log4MT didn't exist; All log events are invoked using the native, single parameter 'log.' commands. During development, the implementer can install wrappers (Using the 'Install Wrappers' macro) which creates a proxy token library. This proxy library houses UDF macros that overwrite and wrap your token library's UDFs. Once the meters are installed, the wrappers will adjust the current level of 'macro-logger' to correspond to the effective logger configuration using the UDF and the token library as a compound category. A typical flow of one of these "wrapped" macros is:
* Some macro calls your user defined function called 'myMacro', which is on the token library lib:myToken
* The wrapper 'myMacro@Lib:myToken-Proxy' will be called instead
* The wrapper will get the effective log level for "lib:myToken.myMacro" and set root logger to that level
* The wrapper will then invoke the actual macro 'myMacro', passing whatever arguments that it was given
* As myMacro executes, the native 'log.' functions will be invoked and those that are invoked at the appropriate priority corresponding to the configured logger will be sent to the log file. This includes 'log' commands that did not define any category in the log messages using the '##' delimiter.
* myMacro will return, possibly with return data. The wrapper macro will then revert the root logger to its previous level and then exit, passing back whatever return data it was given

**Benefits:**
The developer writes their macro without creating any new dependencies to another library or having any concern for generating messages with categories. When wrappers are not enabled, as would be the case when the token library is being used for its intended purpose, there is no added performance impact. Also, this is the only way to get the generated Entry/Exit logging.

**Drawback:**
Wrappers impart a performance* impact as all previous UDFs now impose invocation of additional wrapping and tooling macros. The mitigation to this is that:
* This is intended to be used in a development situation, where performance is not critical
* These wrappers can be easily and quickly disabled and reenabled as the developer requires

<sub>* 1.8.3 has brought vast performance improvements to macros which may mitigate performance drawback </sub>
## Profiling
In addition to the enhanced logging configuration, the installed meters will also capture execution times allowing you to evaluate execution performance. Once Meters are installed and they are enabled, execute your macros as desired. Then use the "Build Profiler Report" to generate CSV performance data. There is a caveat to this data in that the values are inflated as any macros that are deeper in the call stack will include the overhead of the wrapper macros within their call stack. Therefore the timing information has to be taken with a grain of salt as they don't reflect a true native execution profile. However, they do provide a benchmark that can be used to gauge future performance improvements against.
## Stack Traces
Often during macro development, we encounter errors that abnormally terminate the macro execution early. It may not be clear which macro was the one that terminated. Or if it is, it may not be clear what the call stack was that got the execution there in the first place. Both question are solved when meters are installed and the macro crashes. When that happens, use the "Call Stack" macro to show the last known call stack. Keep in mind that this value must manually be cleared for any abnormal termination. Otherwise it will tend to grow in size as new exceptions occur.

## L4m.Break
![l4m.break Screen](https://github.com/mr-ice/maptool-macros/blob/master/Wiki/l4m_break.png)

Breakpoints may be inserted into your macro code using the 'l4m.break' command:
```l4m.break (category, message, 0|1, 0..n parameters)```
> * category - A category chain, very much like what is specified with the 'log.x' commands. The effective ".break" logger for this chain must result in the value 'ENABLED'. If not, the break point will not active.
> * message - Any message to supply
> * 0|1 - Staying the the established MapTool pattern, a value of '0' means 'The break will happen' and '1' means it will not. Note: This means that in order for the macro to break, the condition must be 0 AND the effect .break logger must be ENABLED.
> * parameters - The remaining parameters are strings which identify variables you wish to include in the break dialog.

## Examples
For additional, refer to the [Log4MT Cookbook](https://github.com/mr-ice/maptool-macros/wiki/Log4MT-Cookbook)
