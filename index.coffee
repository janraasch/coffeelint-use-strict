'use strict'
isUseStrictValue = (node) ->
    (node.constructor.name is 'Value') and
    node.isString() and
    (node.base.value is '"use strict"' or
    node.base.value is "'use strict'")

useStrictAtTopOf = (node) ->
    firstChild = null

    # let's not bother with empty nodes
    # i.e. empty functions
    return {boolean: true} if node.isEmpty()

    # get first child
    node.eachChild (child) ->
        firstChild = child
        false

    # return result
    boolean: isUseStrictValue firstChild
    firstChild: firstChild

class UseStrictRule
    rule:
        name: 'use_strict'
        level: 'error'
        message: 'Missing \'use strict\' statement'
        allowGlobal: true
        requireGlobal: false
        description: """
            <p>This rule enforces the ussage of strict mode. By setting
            requireGlobal to true, you can also require a file to
            have a global 'use strict' statement at the top. And, by setting
            allowGlobal to true (or false) you can allow
            (or disallow) 'use strict' statements at the top of a file</p>
            <pre><code>
            #
            # If requireGlobal is false
            #

            # Good
            goodfunc = (please) ->
                'use strict'
                allright

            # Bad
            badfunc = (idonot) ->
                obey
            </code></pre>
            """

    lintAST: (node, astApi) ->
        createError = astApi.createError
        {requireGlobal, allowGlobal} = astApi.config[@rule.name]
        firstChild = null

        # let's not bother with empty nodes
        return undefined if node.isEmpty()

        # check global `use strict`
        useStrict = useStrictAtTopOf node
        if useStrict.boolean is true
            if allowGlobal is off
                @errors.push(
                    createError(
                        lineNumber:
                            useStrict.firstChild.locationData.first_line + 1
                        message:
                            '\'use strict\' at top of file'
                    )
                )
            else
                allowGlobal is on
                # no errors and done
                return undefined
        else
            if requireGlobal is true
                @errors.push(
                    createError(
                        lineNumber:
                            useStrict.firstChild.locationData.first_line + 1
                    )
                )
                return undefined

        # seems like we really need to walk down the tree
        # and find find first level functions
        node.traverseChildren false, (child) =>
            useStr = null
            if child.constructor.name is 'Code'
                useStr = useStrictAtTopOf child.body
                if not useStr.boolean
                    @errors.push(
                        createError(
                            lineNumber:
                                useStr.firstChild.locationData.first_line + 1
                        )
                    )
            true

        undefined


module.exports = UseStrictRule
