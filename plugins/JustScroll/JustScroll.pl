package MT::Plgin::Editing::OMV::JustScroll;
# JustScroll (C) 2012 Piroli YUKARINOMIYA (Open MagicVox.net)
# This program is distributed under the terms of the GNU Lesser General Public License, version 3.
# $Id$

use strict;
use warnings;
use MT 5;

use vars qw( $VENDOR $MYNAME $FULLNAME $VERSION $SCHEMA_VERSION );
$FULLNAME = join '::',
        (($VENDOR, $MYNAME) = (split /::/, __PACKAGE__)[-2, -1]);
(my $revision = '$Rev$') =~ s/\D//g;
$VERSION = 'v0.12'. ($revision ? ".$revision" : '');

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new ({
    id => $FULLNAME,
    key => $FULLNAME,
    name => $MYNAME,
    version => $VERSION,
    author_name => 'Open MagicVox.net',
    author_link => 'http://www.magicvox.net/',
    plugin_link => 'http://www.magicvox.net/archive/2012/05132057/', # Blog
    doc_link => 'http://lab.magicvox.net/trac/mt-plugins/wiki/JustScroll', # tracWiki
    description => <<'HTMLHEREDOC',
<__trans phrase="Automatically focusing and resize the editing textarea">
HTMLHEREDOC
    registry => {
        applications => {
            cms => {
                callbacks => {
                    # Entry/Webpage
                    'template_source.edit_entry' => \&_hdlr_template_source_edit,
                    # Template
                    'template_source.edit_template' => \&_hdlr_template_source_edit,
                },
            },
        },
    },
});
MT->add_plugin ($plugin);

sub instance { $plugin; }



### Callback - MT::App::CMS::template_source.edit_*
sub _hdlr_template_source_edit {
    my ($cb, $app, $tmpl) = @_;

    chomp (my $new = &instance->translate_templatized (<<"MTMLHEREDOC"));
<mt:setvarblock name="jq_js_include" append="1"><mt:if name="id">
// $FULLNAME
// Automatically focusing the textarea for <mt:var object_type>
<mt:if name="object_type" eq="entry">
    jQuery('#editor-header div.tab a').click (function(){
        location.href = '#editor';
    });
    location.href = '#editor';</mt:if>
<mt:if name="object_type" eq="page">
    jQuery('#editor-header div.tab a').click (function(){
        location.href = '#editor';
    });
    location.href = '#editor';</mt:if>
<mt:if name="object_type" eq="template">
    jQuery('#template-editor-toolbar').dblclick (function(){
        location.href = '#template-body-field';
    });
    location.href = '#template-body-field';</mt:if>

    // Ticket #15 - Automatically resizing the textarea to fit against the window height
    var justscroll_offset =
        jQuery('#editor-content-toolbar').outerHeight() +
        jQuery('#editor').outerHeight() +
        3; /* Please adjust as you like */
    function resizeEditorContentTextare () {
        jQuery('#editor-content-textarea').height(jQuery(window).height() - justscroll_offset);
    }
    resizeEditorContentTextare ();
    jQuery(window).bind ('resize', resizeEditorContentTextare);
</mt:if></mt:setvarblock>
MTMLHEREDOC
    $$tmpl =~ s/^/$new/;
}

1;