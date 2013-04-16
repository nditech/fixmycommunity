(function(FMS, Backbone, _, $) {
    _.extend( FMS, {
        Draft: Backbone.Model.extend({
            localStorage: new Backbone.LocalStorage(CONFIG.NAMESPACE + '-drafts'),

            defaults: {
                lat: 0,
                lon: 0,
                title: '',
                details: '',
                may_show_name: '',
                category: '',
                phone: '',
                pc: '',
                file: ''
            }
        })
    });
})(FMS, Backbone, _, $);

(function(FMS, Backbone, _, $) {
    _.extend( FMS, {
        Drafts: Backbone.Collection.extend({
            model: FMS.Draft,
            localStorage: new Backbone.LocalStorage(CONFIG.NAMESPACE + '-drafts')
        })
    });
})(FMS, Backbone, _, $);