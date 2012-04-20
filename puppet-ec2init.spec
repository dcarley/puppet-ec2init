%{?_initddir:%define _initrddir %{_initrddir}}

Name:       puppet-ec2init
Version:    0.1
Release:    1%{?dist}
Summary:    EC2 bootstrapping using Puppet

Group:      System Tools
License:    ASL 2.0
URL:        https://github.com/dcarley/puppet-ec2init
#           git archive --format tar --prefix %{name}-%{version}/ HEAD \
#               | gzip > %{name}-%{version}.tgz
Source0:    %{name}-%{version}.tgz
BuildArch:  noarch
BuildRoot:  %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)

Requires:   curl
Requires:   puppet >= 2.6
Requires:   ec2ddns

%description
Puppet module and sysvinit service to perform initialisation steps for EC2
instances. Additional configuration can be provided by passing JSON over
user-data.

%prep
%setup -q

%build

%install
rm -rf %{buildroot}

install -d %{buildroot}%{_initddir}
install %{name}.init %{buildroot}%{_initddir}/%{name}

install -d %{buildroot}%{_sysconfdir}/%{name}/ec2init
cp -R manifests templates lib %{buildroot}%{_sysconfdir}/%{name}/ec2init/

%clean
rm -rf %{buildroot}

%post
/sbin/chkconfig --add %{name} || :

%preun
if [ "$1" = 0 ] ; then
    /sbin/chkconfig --del %{name} || :
fi

%files
%defattr(-,root,root,-)
%doc README.md
%doc LICENSE.md
%attr(0755, root, root) %{_initddir}/%{name}
%{_sysconfdir}/%{name}

%changelog
* Fri Apr 20 2012 Dan Carley <dan.carley@gmail.com> - 0.1-1
- Initial release.
