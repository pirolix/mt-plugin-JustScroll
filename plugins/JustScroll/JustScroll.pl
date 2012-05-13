package MT::Plgin::Editing::OMV::JustScroll;
# $Id$

use strict;

use vars qw( $VENDOR $MYNAME $VERSION );
($VENDOR, $MYNAME) = (split /::/, __PACKAGE__)[-2, -1];
(my $revision = '$Rev$') =~ s/\D//g;
$VERSION = '0.10'. ($revision ? ".$revision" : '');

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new ({
    id => $MYNAME,
    key => $MYNAME,
    name => $MYNAME,
    version => $VERSION,
    author_name => 'Open MagicVox.net',
    author_link => 'http://www.magicvox.net/',
    plugin_link => 'http://www.magicvox.net/archive/2012/05132057/', # blog
    doc_link => 'http://lab.magicvox.net/trac/mt-plugins/wiki/JustScroll', # trac
    description => <<'HTMLHEREDOC',
<__trans phrase="Automatically focusing the textarea">
HTMLHEREDOC
    registry => {
        callbacks => {
            'MT::App::CMS::template_source.edit_entry' => \&_hdlr_template_source_edit,
            'MT::App::CMS::template_source.edit_template' => \&_hdlr_template_source_edit,
        },
    },
});
MT->add_plugin ($plugin);

sub instance { $plugin; }



sub _hdlr_template_source_edit {
    my ($cb, $app, $tmpl) = @_;

    chomp (my $old = <<'MTMLHEREDOC');
<mt:include name="include/footer.tmpl"
MTMLHEREDOC
    $old = quotemeta $old;

    my $new = &instance->translate_templatized (<<'MTMLHEREDOC');
<mt:setvarblock name="jq_js_include" append="1"><mt:if name="id">
// Automatically focusing the textarea for <mt:var object_type>
<mt:if name="object_type" eq="entry">
    location.href = '#editor';</mt:if>
<mt:if name="object_type" eq="page">
    location.href = '#editor';</mt:if>
<mt:if name="object_type" eq="template">
    location.href = '#template-body-field';</mt:if>
</mt:if></mt:setvarblock>
MTMLHEREDOC
    $$tmpl =~ s/($old)/$new$1/;
}

1;