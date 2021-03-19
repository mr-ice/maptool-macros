[dialog5 ("Logging Configuration Help", "title=Logging Configuration Help; width=600; height=540; closebutton=1"): {
	
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" data-color-mode="light" data-light-theme="light" data-dark-theme="dark">
    <head>

        <link rel="stylesheet"
            href="https://github.githubassets.com/assets/frameworks-a0377fcd177bd314e2941b7dfb73dcd7.css" />
        <link rel="stylesheet"
            href="https://github.githubassets.com/assets/behaviors-491ba1a01271556be855b727e25627ec.css" />
        <link rel="stylesheet"
            href="https://github.githubassets.com/assets/github-d54ca34ebca8e959d84334246e6f3989.css" />

    </head>
    <body class="logged-in env-production page-responsive" style="word-wrap: break-word;">
    <h3> <a href="https://github.com/mr-ice/maptool-macros/wiki/Lib:Log4MT">Latest Documentation</a>
        <h3>
            <a id="user-content-logging-configuration" class="anchor" href="#logging-configuration"
                aria-hidden="true">
               
            </a>Logging Configuration</h3>
        <p>Logging is configured via the "Configure Logging" macro on Lib:Log4MT. Launching it will
            bring up a dialog with a free-form text field (it may need to be resized manually to
            better view it):</p>
        <p><img
                src="https://github.com/mr-ice/maptool-macros/raw/128d10dce6bd82a062382a31af6754d74606baba/Wiki/l4m_cfgLogging.png?raw=true"
                alt="" /></p>
        <p>The configuration is a JSON object where the Key is the logger to configure and the value
            is the log level to define.</p>
        <h4>
            <a id="user-content-key" class="anchor" href="#key" aria-hidden="true">
                
            </a>Key </h4>
        <p>The logger key is in the format of
            &apos;logger.&lbrack;identifier&rbrack;.&lbrack;suffix&rbrack;&apos;.</p>
        <ul>
            <li>Identifier - This is a value corresponding to a Category, Package, or Macro Name.
                Each configuration corresponds to on identifier.</li>
        </ul>
        <blockquote>
            <ul>
                <li>Category - This is a user defined value. It can be anything keeping in mind
                    "root" is a reserved value. Levels configured for root are globally applied to
                    all log events which either specify an undefined category, or no category.</li>
                <li>Package - For complex token libraries with several dozen macros, one may find
                    they rely on a naming scheme that collects macros together, as a package. Macro
                    names are split based on a delimiter character (. and _) to derive these package
                    names. For example, consider the macro "dnd5e_DiceRoller_roll". Two packages are
                    detected in this format: &apos;dnd5e&apos; &amp; &apos;DiceRoller&apos;. Either
                    of these packages may have log configurations defined for them.</li>
                <li>Macro Name - And of course, the macro name itself is an identifier</li>
            </ul>
        </blockquote>
        <ul>
            <li>Suffix - suffixes designate what logger is being defined. For any category, there
                are three loggers:</li>
        </ul>
        <blockquote>
            <ul>
                <li>level - This is used to define standard macro logging. The value specified
                    allows logging at that level and above to filter through to the log from their
                    corresponding log/l4m commands. Eg. the logger
                    &apos;logger.dnd5e_DiceRoller_roll.level:DEBUG&apos; will allow log events from
                    log.debug &amp; l4m.debug and up while filter out log.trace. Wrappers are NOT
                    required for this function.</li>
                <li>entryexit - Is used to define Entry/Exit logging for the specified identifier.
                    The value need only be &apos;ENABLED&apos; or &apos;DISABLED&apos;. When
                    enabled, macros that match the identifier will have entry and exit log events
                    generated. Entry and exit log events are generated using the category
                    &apos;&lbrack;Library Token&rbrack;.&lbrack;Macro Name&rbrack;&apos;. Wrappers
                    ARE REQUIRED for this function.</li>
                <li>break - As with entryexit, break requires only ENABLED or DISABLED. The break
                    loggers correspond to the &apos;l4m.break&apos; command. In order for the
                    l4m.break command to interrupt the macro flow, the passed category must be
                    enabled via this logger configuration. Wrappers are NOT required for this
                    function.</li>
                <li>lineParser - LineParser also requires ENABLED or DISABLED. For any category that
                    has LineParser enabled, the logger
                    "net.rptools.maptool.client.MapToolLineParser" will be set to DEBUG, which
                    enables rather verbose tracing as the macro parser parses your macro. Just as
                    EnterExit, this is a passive only logger requiring wrappers and uses generated
                    categories of &apos;&lbrack;Library Token&rbrack;.&lbrack;Macro
                    Name&rbrack;&apos;</li>
            </ul>
        </blockquote>
        <h4>
            <a id="user-content-log-level" class="anchor" href="#log-level" aria-hidden="true"></a>Log Level</h4>
        <p>Five values are supported (case doesn&apos;t matter): ERROR, WARN, INFO, DEBUG, TRACE.
            For "logger" keys, the it defines the level of log events that will be displayed in the
            log file. Priority starts at ERROR and increases all the way to TRACE. Log events that
            are generated at the same or higher priority will be sent to the log file. For instance,
            if a log even is generated with "log.info", it will only be sent to the log if the
            associated category is configured with INFO, DEBUG, or TRACE.</p>
        <h4>
            <a id="user-content-l4mlog-commands" class="anchor" href="#l4mlog-commands"
                aria-hidden="true"></a>l4m/log commands</h4>
        <p>Lib:Log4MT overwrites &apos;log.x&apos; functions as user defined functions that map to
            their corresponding &apos;l4m.x&apos; function. Therefore, when Lib:Log4MT is installed,
            all &apos;log&apos; commands are actually calling &apos;l4m&apos; commands. Therefore,
            the syntax for &apos;l4m&apos; commands may also apply to &apos;log&apos; commands.
            &apos;log&apos; will be used for the remainder of this documentation, keeping in mind
            &apos;log&apos; and &apos;l4m&apos; are interchangeable.</p>
        <p>All &apos;log.x&apos; functions have two method signatures:</p>
        <blockquote>
            <ul>
                <li>log.x (category, message) - This format has its pros and cons. In this format,
                    the category is explicitly passed apart from the message. However, this
                    signature is specific to Lib:Log4MT and forces Lib:Log4MT to be a dependent
                    library to your macro.</li>
                <li>log.x (message) - This format is the core signature for MapTools &apos;log&apos;
                    functions. Using this loosely couples Lib:Log4MT to your macro, allowing the
                    macro to run completely independently of Lib:Log4MT. Further, Lib:Log4MT can
                    always be re-introduced to the campaign at a later point and the log events will
                    automatically begin leveraging the logging configuration framework. When using
                    this signature, the category can still be defined as part of the log message:
                        <code>log.debug ("Lib:DnD5e.dnd5e_DiceRoller_roll ## This is the actual log
                        message")</code> The secondary delimiter &apos;##&apos; will identify the
                    category from within the log event message.</li>
            </ul>
        </blockquote>
        <h4>
            <a id="user-content-categories" class="anchor" href="#categories" aria-hidden="true"
                    ></a>Categories</h4>
        <p>When executing an active log event using one of the &apos;log&apos; commands, an
            identifier is expected. In the previous section, identifiers were categorized as
            Categories, Packages, and Macro Names. These are effectively overloaded terms as all
            three are internalized as Categories. It&apos;s simply their position in the category
            chain that differentiates them. The category chain may be composed of zero or more
            categories, delimited by the period. All category chains are prepended with the root
            category to ensure they have some corresponding configuration. A typical category chain
            is &lbrack;Library Token&rbrack;.&lbrack;Macro Name&rbrack;. For example, the macro
            &apos;dnd5e_DiceRoller_roll&apos; on the library token &apos;Lib:DnD5e&apos;, as a best
            practice, should use the category chain &apos;Lib:DnD5e.dnd5e_DiceRoller_roll&apos;.
            This category chain will be broken up from left to right, going least significant to
            most significant. The category that is most significant, or on the end of the chain,
            will be further broken up into packages based on the underscore delimiter. These
            packages are inserted into the category chain, making packages more significant than all
            categories, except the last one. Which, by way of best practice, is the macro name.
            Returning to our example &apos;Lib:DnD5e.dnd5e_DiceRoller_roll&apos;, the following
            category chain will be ultimately constructed: <code>&lbrack;root, Lib:DnD5e, dnd5e,
                DiceRoller, dnd5e_DiceRoller_roll&rbrack;</code> The logger will evaluate the
            configured loggers for each category in this chain, starting from the least significant
            &apos;root&apos; and ending with most significant &apos;dnd5e_DiceRoller_roll&apos;. The
            logger defined for the most significant category will be the effective logger for this
            category chain.</p>
    </body>
</html>




}]